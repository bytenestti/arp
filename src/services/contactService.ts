import api from './api';
import { ContactFormData, ContactResponse, ApiError } from '../types/api';

export class ContactService {
  /**
   * Envia uma solicitação de orçamento
   * @param formData - Dados do formulário de contato
   * @returns Promise com a resposta da API
   * 
   * Exemplo de resposta da API FastAPI:
   * {
   *   "success": true,
   *   "message": "Orçamento solicitado com sucesso! Entraremos em contato em breve.",
   *   "id": "contact_123456789"
   * }
   * 
   * Exemplo de erro:
   * {
   *   "error": "Nome, email e telefone são obrigatórios"
   * }
   */
  static async submitContactForm(formData: ContactFormData): Promise<ContactResponse> {
    try {
      const response = await api.post<ContactResponse>('/contact', formData);
      return response.data;
    } catch (error: any) {
      // Tratamento de erro específico para o serviço de contato
      if (error.response?.data) {
        throw new Error(error.response.data.error || 'Erro ao enviar formulário');
      }
      throw new Error('Erro de conexão. Tente novamente.');
    }
  }

  /**
   * Valida os dados do formulário antes do envio
   * @param formData - Dados do formulário
   * @returns boolean indicando se os dados são válidos
   */
  static validateContactForm(formData: ContactFormData): { isValid: boolean; errors: string[] } {
    const errors: string[] = [];

    if (!formData.name?.trim()) {
      errors.push('Nome é obrigatório');
    }

    if (!formData.email?.trim()) {
      errors.push('Email é obrigatório');
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      errors.push('Email inválido');
    }

    if (!formData.phone?.trim()) {
      errors.push('Telefone é obrigatório');
    }

    if (!formData.service?.trim()) {
      errors.push('Serviço é obrigatório');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Formata o número de telefone para exibição
   * @param phone - Número de telefone
   * @returns Número formatado
   */
  static formatPhone(phone: string): string {
    // Remove todos os caracteres não numéricos
    const cleaned = phone.replace(/\D/g, '');
    
    // Formata para (XX) XXXXX-XXXX ou (XX) XXXX-XXXX
    if (cleaned.length === 11) {
      return cleaned.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
    } else if (cleaned.length === 10) {
      return cleaned.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3');
    }
    
    return phone; // Retorna o original se não conseguir formatar
  }
}
