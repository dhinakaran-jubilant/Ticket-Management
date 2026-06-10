import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:443',
        // target: 'http://192.168.0.7:2501',
        changeOrigin: true,
      }
    }
  },
  build: {
    outDir: '../backend/dist',
    emptyOutDir: true,
  }
})
