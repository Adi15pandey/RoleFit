export function cleanText(text) {
  if (!text || typeof text !== 'string') {
    return '';
  }

  return text
    .replace(/\S+@\S+/g, '')
    .replace(/\+?\d[\d\s-]{8,}/g, '')
    .replace(/\s+/g, ' ')
    .replace(/\n+/g, ' ')
    .trim()
    .substring(0, 512);
}
