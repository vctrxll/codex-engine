import { museumRepository } from './museum.repository'

export const museumService = {
    async getAll(db: D1Database) {
        const { results } = await museumRepository.getAll(db)
        return results
    },

    async getById(db: D1Database, id: number) {
        return await museumRepository.getById(db, id)
    },

    async create(db: D1Database, data: any) {
        if (!data.name) {
            throw new Error('Name is required')
        }

        const result = await museumRepository.create(db, data)

        return {
            id: result.meta.last_row_id,
            ...data
        }
    }
}