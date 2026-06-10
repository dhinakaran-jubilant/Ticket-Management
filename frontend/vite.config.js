import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const apiTarget = env.VITE_API_URL || 'http://127.0.0.1:2501'

  return {
    plugins: [react()],
    server: {
      proxy: {
        '/api': {
          target: apiTarget,   // Set VITE_API_URL in .env to switch targets
          changeOrigin: true,
        }
      }
    },
    build: {
      outDir: '../backend/dist',
      emptyOutDir: true,
    }
  }
})
