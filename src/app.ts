import { Hono } from 'hono'
import { museumRoutes } from './modules/museum/museum.routes'

const app = new Hono

app.route('/api/museums', museumRoutes)

export default app