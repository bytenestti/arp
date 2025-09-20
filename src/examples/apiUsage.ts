// Exemplos de como usar os serviços da API

import { ContactService, ServicesService, AboutService } from '../services';

// Exemplo 1: Enviar formulário de contato
export const submitContactExample = async () => {
  const formData = {
    name: 'João Silva',
    email: 'joao@email.com',
    phone: '(31) 99851-2887',
    service: 'poda',
    message: 'Preciso de um orçamento para poda de árvores no meu jardim.'
  };

  try {
    const response = await ContactService.submitContactForm(formData);
    console.log('Formulário enviado com sucesso:', response);
  } catch (error) {
    console.error('Erro ao enviar formulário:', error);
  }
};

// Exemplo 2: Buscar todos os serviços
export const getServicesExample = async () => {
  try {
    const services = await ServicesService.getAllServices();
    console.log('Serviços disponíveis:', services);
  } catch (error) {
    console.error('Erro ao buscar serviços:', error);
    // Usar serviços padrão em caso de erro
    const defaultServices = ServicesService.getDefaultServices();
    console.log('Usando serviços padrão:', defaultServices);
  }
};

// Exemplo 3: Buscar serviço específico
export const getServiceByIdExample = async () => {
  try {
    const service = await ServicesService.getServiceById('poda');
    console.log('Serviço de poda:', service);
  } catch (error) {
    console.error('Erro ao buscar serviço:', error);
  }
};

// Exemplo 4: Buscar informações da empresa
export const getCompanyInfoExample = async () => {
  try {
    const companyInfo = await AboutService.getCompanyInfo();
    console.log('Informações da empresa:', companyInfo);
  } catch (error) {
    console.error('Erro ao buscar informações:', error);
    // Usar informações padrão em caso de erro
    const defaultInfo = AboutService.getDefaultCompanyInfo();
    console.log('Usando informações padrão:', defaultInfo);
  }
};

// Exemplo 5: Buscar estatísticas
export const getStatisticsExample = async () => {
  try {
    const statistics = await AboutService.getCompanyStatistics();
    console.log('Estatísticas da empresa:', statistics);
  } catch (error) {
    console.error('Erro ao buscar estatísticas:', error);
  }
};

// Exemplo 6: Buscar serviços com filtros
export const searchServicesExample = async () => {
  try {
    const services = await ServicesService.searchServices({
      category: 'jardinagem',
      price_min: 100,
      price_max: 500,
      search: 'poda'
    });
    console.log('Serviços filtrados:', services);
  } catch (error) {
    console.error('Erro ao buscar serviços filtrados:', error);
  }
};

// Exemplo 7: Validar formulário antes do envio
export const validateFormExample = () => {
  const formData = {
    name: '',
    email: 'email-invalido',
    phone: '',
    service: '',
    message: 'Teste'
  };

  const validation = ContactService.validateContactForm(formData);
  console.log('Validação do formulário:', validation);
  
  if (!validation.isValid) {
    console.log('Erros encontrados:', validation.errors);
  }
};

// Exemplo 8: Formatar telefone
export const formatPhoneExample = () => {
  const phone1 = '11999999999';
  const phone2 = '1133333333';
  
  console.log('Telefone formatado 1:', ContactService.formatPhone(phone1));
  console.log('Telefone formatado 2:', ContactService.formatPhone(phone2));
};
