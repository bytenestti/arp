import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    default: "ARP Manutenções - Especialistas em Poda e Jardinagem | Ouro Preto/MG",
    template: "%s | ARP Manutenções"
  },
  description: "Serviços profissionais de poda e corte de árvores, jardinagem e limpeza pós-obra em Ouro Preto/MG. Transformamos seu espaço com qualidade, segurança e experiência de 5+ anos.",
  icons: {
    icon: '/favicon.svg',
    shortcut: '/favicon.svg',
    apple: '/favicon.svg',
  },
  keywords: [
    "poda de árvores",
    "corte de árvores", 
    "jardinagem profissional",
    "limpeza pós-obra",
    "manutenção de jardim",
    "paisagismo",
    "Ouro Preto",
    "Minas Gerais",
    "MG",
    "árvores",
    "jardim",
    "poda",
    "corte",
    "limpeza"
  ],
  authors: [{ name: "ARP Manutenções" }],
  creator: "ARP Manutenções",
  publisher: "ARP Manutenções",
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  metadataBase: new URL('https://arpmanutencoes.com'),
  alternates: {
    canonical: '/',
  },
  openGraph: {
    type: 'website',
    locale: 'pt_BR',
    url: 'https://arpmanutencoes.com',
    siteName: 'ARP Manutenções',
    title: 'ARP Manutenções - Especialistas em Poda e Jardinagem',
    description: 'Serviços profissionais de poda e corte de árvores, jardinagem e limpeza pós-obra em Ouro Preto/MG. Transformamos seu espaço com qualidade e segurança.',
    images: [
      {
        url: '/img/banner.jpg',
        width: 1200,
        height: 630,
        alt: 'ARP Manutenções - Serviços de Jardinagem e Poda',
      },
    ],
  },
  twitter: {
    card: 'summary_large_image',
    title: 'ARP Manutenções - Especialistas em Poda e Jardinagem',
    description: 'Serviços profissionais de poda e corte de árvores, jardinagem e limpeza pós-obra em Ouro Preto/MG.',
    images: ['/img/banner.jpg'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  verification: {
    google: 'seu-google-verification-code',
    yandex: 'seu-yandex-verification-code',
    yahoo: 'seu-yahoo-verification-code',
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const structuredData = {
    "@context": "https://schema.org",
    "@graph": [
      {
        "@type": "Organization",
        "@id": "https://arpmanutencoes.com/#organization",
        "name": "ARP Manutenções",
        "url": "https://arpmanutencoes.com",
        "logo": {
          "@type": "ImageObject",
          "url": "https://arpmanutencoes.com/logo.png",
          "width": 200,
          "height": 60
        },
        "contactPoint": {
          "@type": "ContactPoint",
          "telephone": "+55-31-99851-2887",
          "contactType": "customer service",
          "areaServed": "BR",
          "availableLanguage": "Portuguese"
        },
        "address": {
          "@type": "PostalAddress",
          "addressLocality": "Ouro Preto",
          "addressRegion": "MG",
          "addressCountry": "BR"
        },
        "sameAs": [
          "https://www.instagram.com/arp_manutencoes",
          "https://wa.me/553198512887"
        ]
      },
      {
        "@type": "WebSite",
        "@id": "https://arpmanutencoes.com/#website",
        "url": "https://arpmanutencoes.com",
        "name": "ARP Manutenções",
        "description": "Serviços profissionais de poda e corte de árvores, jardinagem e limpeza pós-obra",
        "publisher": {
          "@id": "https://arpmanutencoes.com/#organization"
        },
        "potentialAction": [
          {
            "@type": "SearchAction",
            "target": {
              "@type": "EntryPoint",
              "urlTemplate": "https://arpmanutencoes.com/?s={search_term_string}"
            },
            "query-input": "required name=search_term_string"
          }
        ]
      },
      {
        "@type": "Service",
        "@id": "https://arpmanutencoes.com/#services",
        "name": "Serviços de Jardinagem e Poda",
        "description": "Serviços profissionais de poda e corte de árvores, jardinagem e limpeza pós-obra",
        "provider": {
          "@id": "https://arpmanutencoes.com/#organization"
        },
        "areaServed": {
          "@type": "City",
          "name": "Ouro Preto",
          "containedInPlace": {
            "@type": "State",
            "name": "Minas Gerais"
          }
        },
        "hasOfferCatalog": {
          "@type": "OfferCatalog",
          "name": "Serviços de Manutenção",
          "itemListElement": [
            {
              "@type": "Offer",
              "itemOffered": {
                "@type": "Service",
                "name": "Poda e Corte de Árvores",
                "description": "Serviços especializados de poda, corte e remoção de árvores"
              }
            },
            {
              "@type": "Offer",
              "itemOffered": {
                "@type": "Service",
                "name": "Jardinagem Profissional",
                "description": "Cuidados especializados para jardins, gramados e áreas verdes"
              }
            },
            {
              "@type": "Offer",
              "itemOffered": {
                "@type": "Service",
                "name": "Limpeza Pós-Obra",
                "description": "Serviços completos de limpeza e organização após reformas"
              }
            }
          ]
        }
      }
    ]
  };

  return (
    <html lang="pt-BR">
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }}
        />
      </head>
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
