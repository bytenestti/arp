'use client';

import { useState } from 'react';

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  return (
    <header className="bg-white/95 backdrop-blur-md shadow-xl border-b border-green-100 fixed w-full top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center py-4">
          {/* Logo */}
          <div className="flex items-center">
            <div className="flex-shrink-0">
              <h1 className="text-2xl font-bold bg-gradient-to-r from-green-600 to-emerald-600 bg-clip-text text-transparent">
                ARP<span className="text-gray-800">Manutenções</span>
              </h1>
            </div>
          </div>

          {/* Desktop Navigation */}
          <nav className="hidden md:flex space-x-8">
            <a href="#inicio" className="text-gray-700 hover:text-green-600 transition-all duration-300 font-medium relative group">
              Início
              <span className="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-green-600 to-emerald-600 transition-all duration-300 group-hover:w-full"></span>
            </a>
            <a href="#servicos" className="text-gray-700 hover:text-green-600 transition-all duration-300 font-medium relative group">
              Serviços
              <span className="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-green-600 to-emerald-600 transition-all duration-300 group-hover:w-full"></span>
            </a>
            <a href="#sobre" className="text-gray-700 hover:text-green-600 transition-all duration-300 font-medium relative group">
              Sobre
              <span className="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-green-600 to-emerald-600 transition-all duration-300 group-hover:w-full"></span>
            </a>
            <a href="#contato" className="text-gray-700 hover:text-green-600 transition-all duration-300 font-medium relative group">
              Contato
              <span className="absolute -bottom-1 left-0 w-0 h-0.5 bg-gradient-to-r from-green-600 to-emerald-600 transition-all duration-300 group-hover:w-full"></span>
            </a>
          </nav>

          {/* CTA Button */}
          <div className="hidden md:block">
            <a
              href="#contato"
              className="bg-gradient-to-r from-green-600 to-emerald-600 text-white px-6 py-3 rounded-full hover:from-green-700 hover:to-emerald-700 transition-all duration-300 shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 font-semibold"
            >
              Solicitar Orçamento
            </a>
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden">
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="text-gray-700 hover:text-green-600 focus:outline-none"
            >
              <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                {isMenuOpen ? (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                ) : (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                )}
              </svg>
            </button>
          </div>
        </div>

        {/* Mobile Navigation */}
        {isMenuOpen && (
          <div className="md:hidden">
            <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3 bg-white border-t">
              <a href="#inicio" className="block px-3 py-2 text-gray-700 hover:text-green-600">
                Início
              </a>
              <a href="#servicos" className="block px-3 py-2 text-gray-700 hover:text-green-600">
                Serviços
              </a>
              <a href="#sobre" className="block px-3 py-2 text-gray-700 hover:text-green-600">
                Sobre
              </a>
              <a href="#contato" className="block px-3 py-2 text-gray-700 hover:text-green-600">
                Contato
              </a>
              <a
                href="#contato"
                className="block px-3 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 text-center"
              >
                Solicitar Orçamento
              </a>
            </div>
          </div>
        )}
      </div>
    </header>
  );
}
