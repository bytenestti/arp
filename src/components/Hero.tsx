import Image from 'next/image';

export default function Hero() {
  return (
    <section id="inicio" className="pt-20 bg-gradient-to-br from-green-500 via-emerald-600 to-teal-600 min-h-screen flex items-center relative overflow-hidden">
      {/* Background Elements */}
      <div className="absolute inset-0 opacity-40">
        <div className="absolute inset-0" style={{
          backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%2310b981' fill-opacity='0.05'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`
        }}></div>
      </div>
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12 relative z-10">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          {/* Content */}
          <div className="text-center lg:text-left">
            <h1 className="text-4xl md:text-6xl font-bold text-white mb-6 leading-tight">
              <span className="bg-gradient-to-r from-yellow-300 to-orange-300 bg-clip-text text-transparent">ARP Manutenções</span>{' '}
              transforma seu{' '}
              <span className="bg-gradient-to-r from-yellow-300 to-orange-300 bg-clip-text text-transparent">espaço verde</span>{' '}
              com{' '}
              <span className="bg-gradient-to-r from-yellow-200 to-orange-200 bg-clip-text text-transparent">excelência</span>
            </h1>
            <p className="text-xl text-green-100 mb-8 leading-relaxed max-w-2xl">
              Oferecemos serviços profissionais de poda e corte de árvores, jardinagem 
              e limpeza pós-obra. Transformamos seu espaço com qualidade, segurança e 
              respeito ao meio ambiente.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
              <a
                href="#contato"
                className="bg-gradient-to-r from-yellow-400 to-orange-500 text-white px-8 py-4 rounded-full text-lg font-semibold hover:from-yellow-500 hover:to-orange-600 transition-all duration-300 shadow-xl hover:shadow-2xl transform hover:-translate-y-1"
              >
                🌿 Solicitar Orçamento
              </a>
              <a
                href="#servicos"
                className="border-2 border-white text-white px-8 py-4 rounded-full text-lg font-semibold hover:bg-white hover:text-green-600 transition-all duration-300 backdrop-blur-sm"
              >
                Ver Serviços
              </a>
            </div>
          </div>

          {/* Image Card */}
          <div className="relative">
            <div className="bg-white/80 backdrop-blur-sm rounded-3xl shadow-2xl p-4 border border-green-100 overflow-hidden">
              <div className="relative rounded-2xl overflow-hidden">
                <Image
                  src="/img/banner.jpg"
                  alt="ARPManutenções - Serviços de Jardinagem e Poda"
                  width={600}
                  height={400}
                  className="w-full h-auto object-cover rounded-2xl"
                  priority
                />
              </div>
            </div>
          </div>

        </div>
      </div>
    </section>
  );
}
