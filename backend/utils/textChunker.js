export function chunkText(text, maxChunkSize = 500, overlap = 50) {
  if (!text || text.length <= maxChunkSize) {
    return [text];
  }

  const chunks = [];
  let start = 0;

  while (start < text.length) {
    let end = start + maxChunkSize;
    
    if (end < text.length) {
      const lastSpace = text.lastIndexOf(' ', end);
      if (lastSpace > start) {
        end = lastSpace;
      }
    }

    chunks.push(text.substring(start, end).trim());
    start = end - overlap;
    
    if (start >= text.length) break;
  }

  return chunks.filter(chunk => chunk.length > 0);
}

