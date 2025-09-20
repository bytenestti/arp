"use client";

export default function Services() {
  const services = [
    {
      title: "Poda e Corte de Árvores",
      description: "Serviços especializados de poda, corte e remoção de árvores com segurança e técnica profissional.",
      features: [
        "Poda de formação e manutenção",
        "Corte de árvores de grande porte",
        "Remoção de árvores mortas",
        "Tratamento de pragas e doenças"
      ],
      link: "/servicos/poda-corte",
      whatsappMessage: "Olá! Gostaria de solicitar um orçamento para serviços de *Poda e Corte de Árvores*. Podem me ajudar?",
      icon: (
        <svg className="w-12 h-12 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z" />
        </svg>
      )
    },
    {
      title: "Jardinagem Profissional",
      description: "Cuidados especializados para jardins, gramados e áreas verdes com técnicas modernas.",
      features: [
        "Plantio e manutenção de jardins",
        "Corte e manutenção de gramados",
        "Paisagismo e design",
        "Irrigação e fertilização"
      ],
      link: "/servicos/jardinagem",
      whatsappMessage: "Olá! Gostaria de solicitar um orçamento para *Jardinagem Profissional*. Podem me ajudar?",
      icon: (
        <svg className="w-12 h-12 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z" />
        </svg>
      )
    },
    {
      title: "Limpeza Pós-Obra",
      description: "Serviços completos de limpeza e organização após reformas e construções.",
      features: [
        "Remoção de entulhos",
        "Limpeza profunda de canteiros",
        "Organização de materiais",
        "Finalização de obras"
      ],
      link: "/servicos/limpeza-pos-obra",
      whatsappMessage: "Olá! Gostaria de solicitar um orçamento para *Limpeza Pós-Obra*. Podem me ajudar?",
      icon: (
        <svg className="w-12 h-12 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
        </svg>
      )
    }
  ];

  return (
    <section id="servicos" className="py-20 bg-gradient-to-b from-white to-green-50 relative overflow-hidden">
      {/* Background Pattern */}
      <div className="absolute inset-0">
        <div className="absolute inset-0" style={{
          backgroundImage: `url("data:image/svg+xml,%3Csvg width='40' height='40' viewBox='0 0 40 40' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%2310b981' fill-opacity='0.03'%3E%3Cpath d='M20 20c0-5.5-4.5-10-10-10s-10 4.5-10 10 4.5 10 10 10 10-4.5 10-10zm10 0c0-5.5-4.5-10-10-10s-10 4.5-10 10 4.5 10 10 10 10-4.5 10-10z'/%3E%3C/g%3E%3C/svg%3E")`
        }}></div>
      </div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
            Soluções{' '}
            <span className="bg-gradient-to-r from-green-600 to-emerald-600 bg-clip-text text-transparent">
              Completas
            </span>{' '}
            em Jardinagem
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
            Oferecemos soluções completas em manutenção e jardinagem com qualidade, 
            segurança e compromisso com o meio ambiente.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          {services.map((service, index) => (
            <div key={index} className="group relative bg-white/90 backdrop-blur-sm rounded-3xl shadow-2xl hover:shadow-3xl transition-all duration-700 p-8 border border-green-100/50 hover:border-green-300/70 transform hover:-translate-y-3 hover:scale-105 flex flex-col h-full overflow-hidden">
              {/* Background Gradient Overlay */}
              <div className="absolute inset-0 bg-gradient-to-br from-green-50/30 via-emerald-50/20 to-teal-50/30 opacity-0 group-hover:opacity-100 transition-opacity duration-500 rounded-3xl"></div>
              
              {/* Decorative Elements */}
              <div className="absolute top-4 right-4 w-20 h-20 bg-gradient-to-br from-green-100/40 to-emerald-100/40 rounded-full blur-xl group-hover:scale-150 transition-transform duration-700"></div>
              <div className="absolute bottom-4 left-4 w-16 h-16 bg-gradient-to-br from-emerald-100/30 to-teal-100/30 rounded-full blur-lg group-hover:scale-125 transition-transform duration-700"></div>
              
              {/* Card Link - Makes entire card clickable */}
              <a href={service.link} className="absolute inset-0 z-10" aria-label={`Ver detalhes de ${service.title}`}></a>
              
              <div className="relative z-0">
                {/* Icon Container */}
                <div className="flex items-center justify-center w-24 h-24 bg-gradient-to-br from-green-500 via-emerald-500 to-teal-500 rounded-3xl mx-auto mb-6 group-hover:scale-110 group-hover:rotate-3 transition-all duration-500 shadow-xl">
                  <div className="w-20 h-20 bg-white/20 backdrop-blur-sm rounded-2xl flex items-center justify-center">
                    {service.icon}
                  </div>
                </div>
                
                {/* Title */}
                <h3 className="text-2xl font-bold text-gray-900 mb-4 text-center group-hover:text-green-700 transition-colors duration-300">
                  {service.title}
                </h3>
                
                {/* Description */}
                <p className="text-gray-600 mb-6 text-center leading-relaxed group-hover:text-gray-700 transition-colors duration-300">
                  {service.description}
                </p>
                
                {/* Features List */}
                <ul className="space-y-4 mb-8 flex-grow">
                  {service.features.map((feature, featureIndex) => (
                    <li key={featureIndex} className="flex items-center text-gray-700 group-hover:text-gray-800 transition-colors duration-300">
                      <div className="w-8 h-8 bg-gradient-to-br from-green-500 to-emerald-600 rounded-xl flex items-center justify-center mr-4 flex-shrink-0 shadow-lg group-hover:shadow-xl transition-shadow duration-300">
                        <svg className="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                        </svg>
                      </div>
                      <span className="font-medium">{feature}</span>
                    </li>
                  ))}
                </ul>
              </div>
              
              {/* Button - Always at bottom */}
              <div className="text-center mt-auto pt-4 relative z-20">
                <a
                  href={`https://wa.me/5511999999999?text=${encodeURIComponent(service.whatsappMessage)}`}
                  target="_blank"
                  rel="noopener noreferrer"
                  onClick={(e) => e.stopPropagation()}
                  className="inline-block bg-gradient-to-r from-green-600 via-emerald-600 to-teal-600 text-white px-8 py-4 rounded-2xl hover:from-green-700 hover:via-emerald-700 hover:to-teal-700 transition-all duration-300 font-bold shadow-xl hover:shadow-2xl transform hover:-translate-y-1 hover:scale-105 relative overflow-hidden group/btn"
                >
                  <span className="relative z-10 flex items-center justify-center gap-2">
                    <span>📱</span>
                    <span>Solicitar Orçamento</span>
                  </span>
                  <div className="absolute inset-0 bg-gradient-to-r from-white/20 to-transparent opacity-0 group-hover/btn:opacity-100 transition-opacity duration-300"></div>
                </a>
              </div>
            </div>
          ))}
        </div>

        {/* Statistics Section */}
        <div className="mt-16 bg-white rounded-2xl p-8 border border-gray-100">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
            <div className="group">
              <div className="text-4xl font-bold text-green-600 mb-2 group-hover:scale-105 transition-transform duration-300">
                +50
              </div>
              <div className="text-gray-600 font-medium">
                Projetos Realizados
              </div>
            </div>
            <div className="group">
              <div className="text-4xl font-bold text-emerald-600 mb-2 group-hover:scale-105 transition-transform duration-300">
                5+
              </div>
              <div className="text-gray-600 font-medium">
                Anos de Experiência
              </div>
            </div>
            <div className="group">
              <div className="text-4xl font-bold text-teal-600 mb-2 group-hover:scale-105 transition-transform duration-300">
                100%
              </div>
              <div className="text-gray-600 font-medium">
                Satisfação do Cliente
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
