import { Hono } from 'hono'
import { museumService } from './museum.service'
import { success, error } from '../../shared/response'
import { getDB } from '../../shared/db'

export const museumRoutes = new Hono<{ Bindings: { codex_db: D1Database } }>()


museumRoutes.get('/', async (c) => {
    const db = getDB(c)
    const data = await museumService.getAll(db)
    return c.json(success(data))
})

museumRoutes.get('/:id', async (c) => {
    const db = getDB(c)
    const id = Number(c.req.param('id'))

    const museum = await museumService.getById(db, id)

    if (!museum) {
        return c.json(error('Not found'), 404)
    }

    return c.json(success(museum))
})

museumRoutes.post('/', async (c) => {
    const db = getDB(c)
    const body = await c.req.json()

    const created = await museumService.create(db, body)

    return c.json(success(created), 201)
})