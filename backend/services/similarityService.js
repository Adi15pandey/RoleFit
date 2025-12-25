export function cosineSimilarity(vec1, vec2) {
  if (!vec1 || !vec2) {
    throw new Error('Both vectors are required');
  }

  if (vec1.length !== vec2.length) {
    throw new Error('Vectors must have the same length');
  }

  let dotProduct = 0;
  let norm1 = 0;
  let norm2 = 0;

  for (let i = 0; i < vec1.length; i++) {
    dotProduct += vec1[i] * vec2[i];
    norm1 += vec1[i] * vec1[i];
    norm2 += vec2[i] * vec2[i];
  }

  const denominator = Math.sqrt(norm1) * Math.sqrt(norm2);
  
  if (denominator === 0) {
    return 0;
  }

  return dotProduct / denominator;
}

export function similarityToPercentage(similarity) {
  const normalized = Math.max(0, Math.min(1, (similarity + 1) / 2));
  return Math.round(normalized * 100);
}
