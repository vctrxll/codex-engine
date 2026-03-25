import { Hono } from 'hono'
import { museumRoutes } from './modules/museum/museum.routes'

const app = new Hono

app.route('/museums', museumRoutes)

export default app