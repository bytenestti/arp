// Tipos para o formulário de contato
export interface ContactFormData {
  name: string;
  email: string;
  phone: string;
  service: string;
  message?: string;
}

export interface ContactResponse {
  success: boolean;
  message: string;
  id?: string;
}

// Tipos para serviços
export interface Service {
  id: string;
  title: string;
  description: string;
  features: string[];
  icon?: string;
  price_range?: string;
  duration?: string;
}

export interface ServicesResponse {
  services: Service[];
  total: number;
}

// Tipos para informações da empresa
export interface CompanyInfo {
  name: string;
  description: string;
  mission: string;
  values: {
    title: string;
    description: string;
  }[];
  team: {
    title: string;
    description: string;
  };
  equipment: {
    title: string;
    description: string;
  };
  personalized_service: {
    title: string;
    description: string;
  };
  contact_info: {
    phone: string[];
    email: string[];
    address: string;
    working_hours: string[];
  };
  statistics: {
    projects_completed: number | string;
    years_experience: number;
    customer_satisfaction: number;
  };
}

export interface AboutResponse {
  company: CompanyInfo;
}

// Tipos para respostas de erro
export interface ApiError {
  error: string;
  details?: string;
  code?: string;
}

// Tipos para respostas de sucesso genéricas
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  message?: string;
  error?: string;
}
