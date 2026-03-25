import { museumRepository } from './museum.repository'
import type { CreateMuseumDTO, Museum } from './museum.types'
import { BadRequestError } from '../../shared/errors'

export const museumService = {
    async getAll(db: D1Database) {
        const { results } = await museumRepository.getAll(db)
        return results
    },

    async getById(db: D1Database, id: number) {
        return await museumRepository.getById(db, id)
    },

    async create(db: D1Database, data: CreateMuseumDTO): Promise<Museum> {
        // 🔹 NORMALIZACIÓN
        const normalizedData = {
            name: data.name?.trim(),
            city: data.city?.trim(),
            state: data.state?.trim(),
            country: data.country?.trim(),
            description: data.description?.trim(),
            website: data.website?.trim(),
            contact_email: data.contact_email?.trim()
        }

        if (!normalizedData.name || !normalizedData.city || !normalizedData.state || !normalizedData.country || !normalizedData.description || !normalizedData.website || !normalizedData.contact_email) {
            throw new BadRequestError('Missing required fields: name, city, state, country, description, website, contact_email')
        }



        const safeData = {
            name: normalizedData.name!,
            city: normalizedData.city!,
            state: normalizedData.state!,
            country: normalizedData.country!,
            description: normalizedData.description!,
            website: normalizedData.website!,
            contact_email: normalizedData.contact_email!
        }

        // 🔹 REGLA DE NEGOCIO (ejemplo)
        // const existing = await museumRepository.findByName(db, normalizedData.name)
        // if (existing) throw new BadRequestError('Museum already exists')

        const result = await museumRepository.create(db, safeData)

        return {
            id: result.meta.last_row_id,
            ...safeData
        }
    }
}