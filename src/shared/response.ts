// shared/response.ts

export type ApiResponse<T = any> = {
    success: boolean
    data?: T
    message?: string
}

export const success = <T>(data: T): ApiResponse<T> => ({
    success: true,
    data
})

export const error = (message: string): ApiResponse => ({
    success: false,
    message
})