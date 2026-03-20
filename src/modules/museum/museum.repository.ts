export const museumRepository = {
    getAll(db: D1Database) {
        return db.prepare(`SELECT * FROM museums`).all()
    },

    getById(db: D1Database, id: number) {
        return db.prepare(`SELECT * FROM museums WHERE id = ?`)
            .bind(id)
            .first()
    },

    create(db: D1Database, data: any) {
        return db.prepare(`
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
    }
}