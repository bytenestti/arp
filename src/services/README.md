# Serviços de API - ARPManutenções

Este diretório contém todos os serviços para comunicação com a API FastAPI do projeto ARPManutenções.

## Estrutura

```
src/services/
├── api.ts              # Configuração base do axios
├── contactService.ts   # Serviços para formulário de contato
├── servicesService.ts  # Serviços para listagem de serviços
├── aboutService.ts     # Serviços para informações da empresa
├── index.ts           # Exportações principais
└── README.md          # Este arquivo
```

## Configuração

### Variáveis de Ambiente

Adicione no seu arquivo `.env.local`:

```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Instalação do Axios

```bash
npm install axios
```

## Uso dos Serviços

### 1. Serviço de Contato

```typescript
import { ContactService } from '@/services';

// Enviar formulário de contato
const formData = {
  name: 'João Silva',
  email: 'joao@email.com',
  phone: '(31) 99851-2887',
  service: 'poda',
  message: 'Preciso de um orçamento'
};

try {
  const response = await ContactService.submitContactForm(formData);
  console.log('Sucesso:', response);
} catch (error) {
  console.error('Erro:', error.message);
}

// Validar formulário
const validation = ContactService.validateContactForm(formData);
if (!validation.isValid) {
  console.log('Erros:', validation.errors);
}

// Formatar telefone
const formattedPhone = ContactService.formatPhone('11999999999');
console.log(formattedPhone); // (31) 99851-2887
```

### 2. Serviço de Serviços

```typescript
import { ServicesService } from '@/services';

// Buscar todos os serviços
try {
  const services = await ServicesService.getAllServices();
  console.log('Serviços:', services);
} catch (error) {
  // Usar serviços padrão em caso de erro
  const defaultServices = ServicesService.getDefaultServices();
  console.log('Serviços padrão:', defaultServices);
}

// Buscar serviço específico
const service = await ServicesService.getServiceById('poda');

// Buscar por categoria
const jardinagemServices = await ServicesService.getServicesByCategory('jardinagem');

// Buscar com filtros
const filteredServices = await ServicesService.searchServices({
  category: 'poda',
  price_min: 100,
  price_max: 500,
  search: 'árvores'
});
```

### 3. Serviço de Informações da Empresa

```typescript
import { AboutService } from '@/services';

// Buscar informações da empresa
try {
  const companyInfo = await AboutService.getCompanyInfo();
  console.log('Empresa:', companyInfo);
} catch (error) {
  // Usar informações padrão em caso de erro
  const defaultInfo = AboutService.getDefaultCompanyInfo();
  console.log('Informações padrão:', defaultInfo);
}

// Buscar estatísticas
const statistics = await AboutService.getCompanyStatistics();

// Buscar informações de contato
const contactInfo = await AboutService.getContactInfo();
```

## Hook Personalizado

Use o hook `useContactForm` para facilitar o gerenciamento do formulário:

```typescript
import { useContactForm } from '@/hooks/useContactForm';

function ContactForm() {
  const { isSubmitting, submitStatus, errorMessage, submitForm } = useContactForm();

  const handleSubmit = async (formData) => {
    const success = await submitForm(formData);
    if (success) {
      // Formulário enviado com sucesso
      console.log('Formulário enviado!');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* Seus campos do formulário */}
      {submitStatus === 'success' && <p>Formulário enviado com sucesso!</p>}
      {submitStatus === 'error' && <p>Erro: {errorMessage}</p>}
      <button disabled={isSubmitting}>
        {isSubmitting ? 'Enviando...' : 'Enviar'}
      </button>
    </form>
  );
}
```

## Tratamento de Erros

Todos os serviços incluem tratamento de erros robusto:

- **Erro de conexão**: Retorna mensagem genérica
- **Erro da API**: Retorna mensagem específica do servidor
- **Dados padrão**: Serviços retornam dados padrão quando a API não está disponível

## Tipos TypeScript

Todos os tipos estão definidos em `src/types/api.ts`:

- `ContactFormData`: Dados do formulário de contato
- `ContactResponse`: Resposta do envio do formulário
- `Service`: Estrutura de um serviço
- `CompanyInfo`: Informações da empresa
- `ApiError`: Estrutura de erro da API

## Endpoints da API

Os serviços esperam os seguintes endpoints na API FastAPI:

- `POST /contact` - Enviar formulário de contato
- `GET /services` - Listar todos os serviços
- `GET /services/{id}` - Buscar serviço específico
- `GET /services/search` - Buscar serviços com filtros
- `GET /about` - Informações da empresa
- `GET /about/statistics` - Estatísticas da empresa
- `GET /about/contact` - Informações de contato

## Exemplos de JSON para a API FastAPI

### 1. POST /contact
**Request Body:**
```json
{
  "name": "João Silva",
  "email": "joao@email.com",
  "phone": "(31) 99851-2887",
  "service": "poda",
  "message": "Preciso de um orçamento para poda de árvores no meu jardim."
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "Orçamento solicitado com sucesso! Entraremos em contato em breve.",
  "id": "contact_123456789"
}
```

**Response (Error):**
```json
{
  "error": "Nome, email e telefone são obrigatórios"
}
```

### 2. GET /services
**Response:**
```json
{
  "services": [
    {
      "id": "poda",
      "title": "Poda e Corte de Árvores",
      "description": "Serviços especializados de poda, corte e remoção de árvores com segurança e técnica profissional.",
      "features": [
        "Poda de formação e manutenção",
        "Corte de árvores de grande porte",
        "Remoção de árvores mortas",
        "Tratamento de pragas e doenças"
      ],
      "price_range": "A partir de R$ 150",
      "duration": "2-4 horas"
    }
  ],
  "total": 3
}
```

### 3. GET /about
**Response:**
```json
{
  "company": {
    "name": "ARPManutenções",
    "description": "Somos uma empresa especializada em serviços de manutenção e jardinagem...",
    "mission": "Transformar espaços verdes com qualidade, segurança e respeito ao meio ambiente.",
    "values": [
      {
        "title": "Qualidade Garantida",
        "description": "Utilizamos apenas materiais de primeira qualidade e técnicas comprovadas."
      }
    ],
    "contact_info": {
      "phone": ["(31) 99851-2887"],
      "email": ["contato@arpmanutencoes.com"],
      "address": "Ouro Preto - MG - Atendemos toda a região",
      "working_hours": ["Segunda a Sexta: 7h às 18h", "Sábado: 7h às 12h"]
    },
    "statistics": {
      "projects_completed": 500,
      "years_experience": 5,
      "customer_satisfaction": 100
    }
  }
}
```

> **📋 Nota:** Para ver todos os exemplos completos de JSON, consulte o arquivo `src/services/api-examples.json`

## Exemplos Completos

Veja o arquivo `src/examples/apiUsage.ts` para exemplos completos de uso de todos os serviços.
