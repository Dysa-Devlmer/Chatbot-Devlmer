import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  reactCompiler: true,
  webpack: (config, { isServer }) => {
    if (isServer) {
      // Ignorar archivos problemáticos de libsql
      config.externals = [...(config.externals || []), '@libsql/isomorphic-ws'];
    }
    return config;
  },
  experimental: {
    // Desactivar Turbopack temporalmente para evitar problemas con libsql
    turbo: {
      rules: {
        '*.md': {
          loaders: ['raw-loader'],
          as: '*.js',
        },
      },
    },
  },
};

export default nextConfig;
