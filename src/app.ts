import { Hono } from 'hono'
import { museumRoutes } from './modules/museum/museum.routes'

const app = new Hono<{ Bindings: { codex_db: D1Database } }>()

app.route('/api/museums', museumRoutes)

export default app