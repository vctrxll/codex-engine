import { Hono } from 'hono'
import { basicAuth } from 'hono/basic-auth'
import { etag } from 'hono/etag'
import { prettyJSON } from 'hono/pretty-json'

import { success, error, museumService, artifactService } from './modules'

// ==============================
// TYPES
// ==============================

type Bindings = {
    codex_db: D1Database
}

// ==============================
// APP INIT
// ==============================

const app = new Hono<{ Bindings: Bindings }>()

// ==============================
// MIDDLEWARES
// ==============================

app.use('*', async (c, next) => {
    const start = Date.now()
    await next()
    c.header('X-Response-Time', `${Date.now() - start}ms`)
})

app.use('*', etag())
app.use('/api/*', prettyJSON())

app.use('/api/admin/*', basicAuth({
    username: 'admin',
    password: '1234'
}))

// ==============================
// ROUTES
// ==============================

app.get('/', (c) => c.text('API Museo OK'))

// DEBUG
app.get('/debug', (c) => {
    return c.json({
        hasDB: !!c.env.codex_db
    })
})

// ==============================
// MUSEUMS
// ==============================

app.get('/api/museums', async (c) => {
    const db = c.env.codex_db
    const data = await museumService.getAll(db)
    return c.json(success(data))
})

app.get('/api/museums/:id', async (c) => {
    const db = c.env.codex_db
    const id = Number(c.req.param('id'))

    const museum = await museumService.getById(db, id)

    if (!museum) {
        return c.json(error('Museum not found'), 404)
    }

    return c.json(success(museum))
})

app.post('/api/museums', async (c) => {
    const db = c.env.codex_db
    const body = await c.req.json()

    if (!body.name) {
        return c.json(error('Name is required'), 400)
    }

    const created = await museumService.create(db, body)

    return c.json(success(created), 201)
})

// ==============================
// ARTIFACTS
// ==============================

app.get('/api/artifacts', async (c) => {
    const db = c.env.codex_db
    const data = await artifactService.getAll(db)
    return c.json(success(data))
})

app.post('/api/artifacts', async (c) => {
    const db = c.env.codex_db
    const body = await c.req.json()

    if (!body.name || !body.museum_id) {
        return c.json(error('Missing fields'), 400)
    }

    const created = await artifactService.create(db, body)

    return c.json(success(created), 201)
})

// ==============================
// ERROR HANDLING
// ==============================

app.notFound((c) => c.json(error('Route not found'), 404))

app.onError((err, c) => {
    console.error(err)
    return c.json(error('Internal Server Error'), 500)
})

export default app