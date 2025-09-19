import { useState } from 'react';
import { ContactService } from '../services/contactService';
import { ContactFormData } from '../types/api';

export const useContactForm = () => {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitStatus, setSubmitStatus] = useState<'idle' | 'success' | 'error'>('idle');
  const [errorMessage, setErrorMessage] = useState('');

  const submitForm = async (formData: ContactFormData) => {
    setIsSubmitting(true);
    setSubmitStatus('idle');
    setErrorMessage('');

    try {
      // Validar dados antes do envio
      const validation = ContactService.validateContactForm(formData);
      if (!validation.isValid) {
        setSubmitStatus('error');
        setErrorMessage(validation.errors.join(', '));
        return false;
      }

      // Enviar dados para a API
      const response = await ContactService.submitContactForm(formData);
      
      if (response.success) {
        setSubmitStatus('success');
        return true;
      } else {
        setSubmitStatus('error');
        setErrorMessage('Erro ao enviar formulário');
        return false;
      }
    } catch (error: any) {
      setSubmitStatus('error');
      setErrorMessage(error.message || 'Erro de conexão. Tente novamente.');
      return false;
    } finally {
      setIsSubmitting(false);
    }
  };

  const resetForm = () => {
    setSubmitStatus('idle');
    setErrorMessage('');
  };

  return {
    isSubmitting,
    submitStatus,
    errorMessage,
    submitForm,
    resetForm
  };
};
