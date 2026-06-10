import axios from 'axios';

// Use a relative baseURL when accessed via ngrok, localhost, 127.0.0.1,
// or the LAN server IP (192.168.0.7) so API calls are always relative to
// the current host and avoid mixed-content or cross-origin issues.
const hostname = typeof window !== 'undefined' ? window.location.hostname : '';
const isNgrokOrLocal =
    hostname.includes('ngrok') ||
    hostname === 'localhost' ||
    hostname === '127.0.0.1' ||
    hostname === '192.168.0.7';

const api = axios.create({
    baseURL: isNgrokOrLocal ? '' : (import.meta.env.VITE_API_URL || ''),
    withCredentials: true,
});

export default api;
