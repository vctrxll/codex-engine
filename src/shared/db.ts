// shared/db.ts

import { Context } from 'hono'
import app from "../app";

// ==============================
// TYPES
// ==============================

type Bindings = {
    codex_db: D1Database
}

// ==============================
// GET DB INSTANCE
// ==============================

export const getDB = (c: Context<{ Bindings: Bindings }>): D1Database => {
    const db = c.env.codex_db

    if (!db) {
        throw new Error('Database not available (codex_db binding missing)')
    }

    return db
}