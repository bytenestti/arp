// Arquivo principal para exportar todos os serviços
export { default as api } from './api';
export { ContactService } from './contactService';
export { ServicesService } from './servicesService';
export { AboutService } from './aboutService';

// Re-exportar tipos para facilitar o uso
export type {
  ContactFormData,
  ContactResponse,
  Service,
  ServicesResponse,
  CompanyInfo,
  AboutResponse,
  ApiError,
  ApiResponse
} from '../types/api';
