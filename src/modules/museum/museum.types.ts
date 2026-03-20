export type Museum = {
    id: number
    name: string
    city?: string | null
    state?: string | null
    country?: string | null
    description?: string | null
    website?: string | null
    contact_email?: string | null
}

export type CreateMuseumDTO = Omit<Museum, 'id'>
