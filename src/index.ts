import app from './app'

export default {
    fetch: (request: Request, env: any, ctx: any) => {
        return app.fetch(request, env, ctx)
    }
}