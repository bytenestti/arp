import api from './api';
import { CompanyInfo, AboutResponse } from '../types/api';

export class AboutService {
  /**
   * Busca informações da empresa
   * @returns Promise com as informações da empresa
   * 
   * Exemplo de resposta da API FastAPI:
   * {
   *   "company": {
   *     "name": "ARPManutenções",
   *     "description": "Somos uma empresa especializada em serviços de manutenção e jardinagem, com anos de experiência no mercado. Nossa missão é transformar espaços verdes com qualidade, segurança e respeito ao meio ambiente.",
   *     "mission": "Transformar espaços verdes com qualidade, segurança e respeito ao meio ambiente.",
   *     "values": [
   *       {
   *         "title": "Qualidade Garantida",
   *         "description": "Utilizamos apenas materiais de primeira qualidade e técnicas comprovadas."
   *       },
   *       {
   *         "title": "Segurança em Primeiro Lugar",
   *         "description": "Seguimos rigorosamente todos os protocolos de segurança do trabalho."
   *       },
   *       {
   *         "title": "Sustentabilidade",
   *         "description": "Praticamos métodos sustentáveis e respeitamos o meio ambiente."
   *       }
   *     ],
   *     "team": {
   *       "title": "Nossa Equipe",
   *       "description": "Profissionais qualificados e experientes, prontos para atender suas necessidades com excelência e dedicação."
   *     },
   *     "equipment": {
   *       "title": "Equipamentos Modernos",
   *       "description": "Utilizamos equipamentos de última geração para garantir eficiência e segurança em todos os nossos serviços."
   *     },
   *     "personalized_service": {
   *       "title": "Atendimento Personalizado",
   *       "description": "Cada projeto é único. Desenvolvemos soluções personalizadas para atender às suas necessidades específicas."
   *     },
   *     "contact_info": {
   *       "phone": ["(31) 99851-2887"],
   *       "email": ["contato@arpmanutencoes.com"],
   *       "address": "Ouro Preto - MG - Atendemos toda a região",
   *       "working_hours": ["Segunda a Sexta: 7h às 18h", "Sábado: 7h às 12h"]
   *     },
   *     "statistics": {
   *       "projects_completed": 500,
   *       "years_experience": 5,
   *       "customer_satisfaction": 100
   *     }
   *   }
   * }
   */
  static async getCompanyInfo(): Promise<CompanyInfo> {
    try {
      const response = await api.get<AboutResponse>('/about');
      return response.data.company;
    } catch (error: unknown) {
      if (error && typeof error === 'object' && 'response' in error) {
        const apiError = error as { response?: { data?: { error?: string } } };
        throw new Error(apiError.response?.data?.error || 'Erro ao buscar informações da empresa');
      }
      throw new Error('Erro de conexão. Tente novamente.');
    }
  }

  /**
   * Retorna as informações padrão da empresa caso a API não esteja disponível
   * @returns Informações padrão da empresa
   */
  static getDefaultCompanyInfo(): CompanyInfo {
    return {
      name: 'ARPManutenções',
      description: 'Somos uma empresa especializada em serviços de manutenção e jardinagem, com anos de experiência no mercado. Nossa missão é transformar espaços verdes com qualidade, segurança e respeito ao meio ambiente.',
      mission: 'Transformar espaços verdes com qualidade, segurança e respeito ao meio ambiente.',
      values: [
        {
          title: 'Qualidade Garantida',
          description: 'Utilizamos apenas materiais de primeira qualidade e técnicas comprovadas.'
        },
        {
          title: 'Segurança em Primeiro Lugar',
          description: 'Seguimos rigorosamente todos os protocolos de segurança do trabalho.'
        },
        {
          title: 'Sustentabilidade',
          description: 'Praticamos métodos sustentáveis e respeitamos o meio ambiente.'
        }
      ],
      team: {
        title: 'Nossa Equipe',
        description: 'Profissionais qualificados e experientes, prontos para atender suas necessidades com excelência e dedicação.'
      },
      equipment: {
        title: 'Equipamentos Modernos',
        description: 'Utilizamos equipamentos de última geração para garantir eficiência e segurança em todos os nossos serviços.'
      },
      personalized_service: {
        title: 'Atendimento Personalizado',
        description: 'Cada projeto é único. Desenvolvemos soluções personalizadas para atender às suas necessidades específicas.'
      },
      contact_info: {
        phone: ['(31) 99851-2887'],
        email: ['contato@arpmanutencoes.com'],
        address: 'Ouro Preto - MG - Atendemos toda a região',
        working_hours: ['Segunda a Sexta: 7h às 18h', 'Sábado: 7h às 12h']
      },
      statistics: {
        projects_completed: 500,
        years_experience: 5,
        customer_satisfaction: 100
      }
    };
  }

  /**
   * Busca estatísticas da empresa
   * @returns Promise com as estatísticas
   * 
   * Exemplo de resposta da API FastAPI:
   * {
   *   "statistics": {
   *     "projects_completed": 500,
   *     "years_experience": 5,
   *     "customer_satisfaction": 100
   *   }
   * }
   */
  static async getCompanyStatistics(): Promise<{
    projects_completed: number;
    years_experience: number;
    customer_satisfaction: number;
  }> {
    try {
      const response = await api.get<{ statistics: { projects_completed: number; years_experience: number; customer_satisfaction: number } }>('/about/statistics');
      return response.data.statistics;
    } catch {
      // Retorna estatísticas padrão em caso de erro
      return this.getDefaultCompanyInfo().statistics;
    }
  }

  /**
   * Busca informações de contato
   * @returns Promise com as informações de contato
   * 
   * Exemplo de resposta da API FastAPI:
   * {
   *   "contact_info": {
   *     "phone": ["(31) 99851-2887"],
   *     "email": ["contato@arpmanutencoes.com"],
   *     "address": "Ouro Preto - MG - Atendemos toda a região",
   *     "working_hours": ["Segunda a Sexta: 7h às 18h", "Sábado: 7h às 12h"]
   *   }
   * }
   */
  static async getContactInfo(): Promise<{
    phone: string[];
    email: string[];
    address: string;
    working_hours: string[];
  }> {
    try {
      const response = await api.get<{ contact_info: { phone: string[]; email: string[]; address: string; working_hours: string[] } }>('/about/contact');
      return response.data.contact_info;
    } catch {
      // Retorna informações de contato padrão em caso de erro
      return this.getDefaultCompanyInfo().contact_info;
    }
  }
}
