// ==============================
// HELPERS (RESPUESTAS)
// ==============================

export const success = (data: any) => ({
  success: true,
  data
})

export const error = (message: string) => ({
  success: false,
  message
})

// ==============================
// SERVICES
// ==============================

export const museumService = {
  async getAll(db: D1Database) {
    const { results } = await db.prepare(`SELECT * FROM museums`).all()
    return results
  },

  async getById(db: D1Database, id: number) {
    return await db.prepare(`SELECT * FROM museums WHERE id = ?`)
        .bind(id)
        .first()
  },

  async create(db: D1Database, data: any) {
    const result = await db.prepare(`
      INSERT INTO museums (name, city, state, country, description, website, contact_email)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `)
        .bind(
            data.name,
            data.city,
            data.state,
            data.country,
            data.description,
            data.website,
            data.contact_email
        )
        .run()

    return { id: result.meta.last_row_id, ...data }
  }
}

export const artifactService = {
  async getAll(db: D1Database) {
    const { results } = await db.prepare(`
      SELECT a.*, m.name as museum_name
      FROM artifacts a
      LEFT JOIN museums m ON a.museum_id = m.id
    `).all()

    return results
  },

  async create(db: D1Database, data: any) {
    const result = await db.prepare(`
      INSERT INTO artifacts (name, museum_id, description)
      VALUES (?, ?, ?)
    `)
        .bind(data.name, data.museum_id, data.description)
        .run()

    return { id: result.meta.last_row_id, ...data }
  }
}