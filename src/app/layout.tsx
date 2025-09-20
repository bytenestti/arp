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
  description: "ARP Manutenções oferece serviços profissionais de poda e corte de árvores, jardinagem e limpeza pós-obra em Ouro Preto/MG. Especialistas em manutenção de jardins, paisagismo e cuidado de árvores. Atendemos toda a região de Ouro Preto com qualidade e segurança.",
  icons: {
    icon: '/favicon.svg',
    shortcut: '/favicon.svg',
    apple: '/favicon.svg',
  },
  keywords: [
    "poda de árvores Ouro Preto",
    "corte de árvores MG", 
    "jardinagem profissional Ouro Preto",
    "limpeza pós-obra Minas Gerais",
    "manutenção de jardim Ouro Preto",
    "paisagismo Ouro Preto",
    "poda árvores Ouro Preto MG",
    "jardinagem Ouro Preto",
    "serviços jardinagem Ouro Preto",
    "poda árvores Minas Gerais",
    "corte árvores Ouro Preto",
    "limpeza jardim Ouro Preto",
    "manutenção jardim MG",
    "paisagista Ouro Preto",
    "jardineiro Ouro Preto",
    "Ouro Preto",
    "Minas Gerais",
    "MG",
    "ARP Manutenções"
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
        "contactPoint": [
          {
            "@type": "ContactPoint",
            "telephone": "+55-31-99851-2887",
            "contactType": "customer service",
            "areaServed": ["Ouro Preto", "Minas Gerais", "BR"],
            "availableLanguage": "Portuguese",
            "hoursAvailable": {
              "@type": "OpeningHoursSpecification",
              "dayOfWeek": ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
              "opens": "07:00",
              "closes": "18:00"
            }
          },
          {
            "@type": "ContactPoint",
            "telephone": "+55-31-99851-2887",
            "contactType": "customer service",
            "areaServed": ["Ouro Preto", "Minas Gerais", "BR"],
            "availableLanguage": "Portuguese",
            "hoursAvailable": {
              "@type": "OpeningHoursSpecification",
              "dayOfWeek": "Saturday",
              "opens": "07:00",
              "closes": "12:00"
            }
          }
        ],
        "address": {
          "@type": "PostalAddress",
          "streetAddress": "Ouro Preto",
          "addressLocality": "Ouro Preto",
          "addressRegion": "Minas Gerais",
          "postalCode": "35400-000",
          "addressCountry": "BR"
        },
        "geo": {
          "@type": "GeoCoordinates",
          "latitude": "-20.3856",
          "longitude": "-43.5036"
        },
        "areaServed": [
          {
            "@type": "City",
            "name": "Ouro Preto",
            "containedInPlace": {
              "@type": "State",
              "name": "Minas Gerais"
            }
          },
          {
            "@type": "State", 
            "name": "Minas Gerais"
          }
        ],
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
          "name": "Serviços de Manutenção e Jardinagem",
          "itemListElement": [
            {
              "@type": "Offer",
              "itemOffered": {
                "@type": "Service",
                "name": "Poda de Árvores Ouro Preto",
                "description": "Serviços especializados de poda e corte de árvores em Ouro Preto/MG",
                "areaServed": "Ouro Preto"
              },
              "priceRange": "R$ 150+",
              "availability": "InStock"
            },
            {
              "@type": "Offer",
              "itemOffered": {
                "@type": "Service",
                "name": "Corte de Árvores Ouro Preto",
                "description": "Remoção segura de árvores de grande porte em Ouro Preto",
                "areaServed": "Ouro Preto"
              },
              "priceRange": "R$ 200+",
              "availability": "InStock"
            },
            {
              "@type": "Offer",
              "itemOffered": {
                "@type": "Service",
                "name": "Jardinagem Profissional Ouro Preto",
                "description": "Serviços profissionais de jardinagem e paisagismo em Ouro Preto/MG",
                "areaServed": "Ouro Preto"
              },
              "priceRange": "R$ 200+",
              "availability": "InStock"
            },
            {
              "@type": "Offer",
              "itemOffered": {
                "@type": "Service",
                "name": "Limpeza Pós-Obra Ouro Preto",
                "description": "Serviços de limpeza e organização após reformas em Ouro Preto",
                "areaServed": "Ouro Preto"
              },
              "priceRange": "R$ 300+",
              "availability": "InStock"
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
