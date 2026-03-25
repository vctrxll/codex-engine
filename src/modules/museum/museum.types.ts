export type CreateMuseumDTO = {
    name: string
    city?: string
    state?: string
    country?: string
    description?: string
    website?: string
    contact_email?: string
}

export type Museum = {
    id: number
    name: string
    city: string
    state: string
    country: string
    description: string
    website: string
    contact_email: string
}