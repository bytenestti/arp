import api from './api';
import { Service, ServicesResponse } from '../types/api';

export class ServicesService {
  /**
   * Busca todos os serviços disponíveis
   * @returns Promise com a lista de serviços
   * 
   * Exemplo de resposta da API FastAPI:
   * {
   *   "services": [
   *     {
   *       "id": "poda",
   *       "title": "Poda e Corte de Árvores",
   *       "description": "Serviços especializados de poda, corte e remoção de árvores com segurança e técnica profissional.",
   *       "features": [
   *         "Poda de formação e manutenção",
   *         "Corte de árvores de grande porte",
   *         "Remoção de árvores mortas",
   *         "Tratamento de pragas e doenças"
   *       ],
   *       "price_range": "A partir de R$ 150",
   *       "duration": "2-4 horas"
   *     }
   *   ],
   *   "total": 3
   * }
   */
  static async getAllServices(): Promise<Service[]> {
    try {
      const response = await api.get<ServicesResponse>('/services');
      return response.data.services;
    } catch (error: unknown) {
      if (error && typeof error === 'object' && 'response' in error) {
        const apiError = error as { response?: { data?: { error?: string } } };
        throw new Error(apiError.response?.data?.error || 'Erro ao buscar serviços');
      }
      throw new Error('Erro de conexão. Tente novamente.');
    }
  }

  /**
   * Busca um serviço específico por ID
   * @param serviceId - ID do serviço
   * @returns Promise com os dados do serviço
   * 
   * Exemplo de resposta da API FastAPI:
   * {
   *   "id": "poda",
   *   "title": "Poda e Corte de Árvores",
   *   "description": "Serviços especializados de poda, corte e remoção de árvores com segurança e técnica profissional.",
   *   "features": [
   *     "Poda de formação e manutenção",
   *     "Corte de árvores de grande porte",
   *     "Remoção de árvores mortas",
   *     "Tratamento de pragas e doenças"
   *   ],
   *   "price_range": "A partir de R$ 150",
   *   "duration": "2-4 horas"
   * }
   */
  static async getServiceById(serviceId: string): Promise<Service> {
    try {
      const response = await api.get<Service>(`/services/${serviceId}`);
      return response.data;
    } catch (error: unknown) {
      if (error && typeof error === 'object' && 'response' in error) {
        const apiError = error as { response?: { data?: { error?: string } } };
        throw new Error(apiError.response?.data?.error || 'Erro ao buscar serviço');
      }
      throw new Error('Erro de conexão. Tente novamente.');
    }
  }

  /**
   * Busca serviços por categoria
   * @param category - Categoria dos serviços
   * @returns Promise com a lista de serviços da categoria
   * 
   * Exemplo de resposta da API FastAPI:
   * {
   *   "services": [
   *     {
   *       "id": "jardinagem",
   *       "title": "Jardinagem Profissional",
   *       "description": "Cuidados especializados para jardins, gramados e áreas verdes com técnicas modernas.",
   *       "features": [
   *         "Plantio e manutenção de jardins",
   *         "Corte e manutenção de gramados",
   *         "Paisagismo e design",
   *         "Irrigação e fertilização"
   *       ],
   *       "price_range": "A partir de R$ 200",
   *       "duration": "3-6 horas"
   *     }
   *   ],
   *   "total": 1
   * }
   */
  static async getServicesByCategory(category: string): Promise<Service[]> {
    try {
      const response = await api.get<ServicesResponse>(`/services?category=${category}`);
      return response.data.services;
    } catch (error: unknown) {
      if (error && typeof error === 'object' && 'response' in error) {
        const apiError = error as { response?: { data?: { error?: string } } };
        throw new Error(apiError.response?.data?.error || 'Erro ao buscar serviços por categoria');
      }
      throw new Error('Erro de conexão. Tente novamente.');
    }
  }

  /**
   * Busca serviços com filtros
   * @param filters - Filtros para busca
   * @returns Promise com a lista de serviços filtrados
   * 
   * Exemplo de resposta da API FastAPI:
   * {
   *   "services": [
   *     {
   *       "id": "poda",
   *       "title": "Poda e Corte de Árvores",
   *       "description": "Serviços especializados de poda, corte e remoção de árvores com segurança e técnica profissional.",
   *       "features": [
   *         "Poda de formação e manutenção",
   *         "Corte de árvores de grande porte",
   *         "Remoção de árvores mortas",
   *         "Tratamento de pragas e doenças"
   *       ],
   *       "price_range": "A partir de R$ 150",
   *       "duration": "2-4 horas"
   *     }
   *   ],
   *   "total": 1,
   *   "filters_applied": {
   *     "category": "poda",
   *     "price_min": 100,
   *     "price_max": 500,
   *     "search": "árvores"
   *   }
   * }
   */
  static async searchServices(filters: {
    category?: string;
    price_min?: number;
    price_max?: number;
    search?: string;
  }): Promise<Service[]> {
    try {
      const params = new URLSearchParams();
      
      if (filters.category) params.append('category', filters.category);
      if (filters.price_min) params.append('price_min', filters.price_min.toString());
      if (filters.price_max) params.append('price_max', filters.price_max.toString());
      if (filters.search) params.append('search', filters.search);

      const response = await api.get<ServicesResponse>(`/services/search?${params.toString()}`);
      return response.data.services;
    } catch (error: unknown) {
      if (error && typeof error === 'object' && 'response' in error) {
        const apiError = error as { response?: { data?: { error?: string } } };
        throw new Error(apiError.response?.data?.error || 'Erro ao buscar serviços');
      }
      throw new Error('Erro de conexão. Tente novamente.');
    }
  }

  /**
   * Retorna os serviços padrão caso a API não esteja disponível
   * @returns Lista de serviços padrão
   */
  static getDefaultServices(): Service[] {
    return [
      {
        id: 'poda',
        title: 'Poda e Corte de Árvores',
        description: 'Serviços especializados de poda, corte e remoção de árvores com segurança e técnica profissional.',
        features: [
          'Poda de formação e manutenção',
          'Corte de árvores de grande porte',
          'Remoção de árvores mortas',
          'Tratamento de pragas e doenças'
        ],
        price_range: 'A partir de R$ 150',
        duration: '2-4 horas'
      },
      {
        id: 'jardinagem',
        title: 'Jardinagem Profissional',
        description: 'Cuidados especializados para jardins, gramados e áreas verdes com técnicas modernas.',
        features: [
          'Plantio e manutenção de jardins',
          'Corte e manutenção de gramados',
          'Paisagismo e design',
          'Irrigação e fertilização'
        ],
        price_range: 'A partir de R$ 200',
        duration: '3-6 horas'
      },
      {
        id: 'limpeza',
        title: 'Limpeza Pós-Obra',
        description: 'Serviços completos de limpeza e organização após reformas e construções.',
        features: [
          'Remoção de entulhos',
          'Limpeza profunda de canteiros',
          'Organização de materiais',
          'Finalização de obras'
        ],
        price_range: 'A partir de R$ 300',
        duration: '4-8 horas'
      }
    ];
  }
}
