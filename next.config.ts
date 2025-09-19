import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Configuração para produção
  output: 'standalone',
  
  // Configuração de domínios permitidos
  images: {
    domains: ['arpmanutencoes.com', 'www.arpmanutencoes.com'],
  },
  
  // Configuração de headers de segurança
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin',
          },
        ],
      },
    ];
  },
  
  // Configuração de redirecionamentos
  async redirects() {
    return [
      {
        source: '/www.arpmanutencoes.com/:path*',
        destination: 'https://arpmanutencoes.com/:path*',
        permanent: true,
      },
    ];
  },
};

export default nextConfig;
