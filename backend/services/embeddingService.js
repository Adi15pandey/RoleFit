const HUGGINGFACE_API_URL = 
  'https://router.huggingface.co/pipeline/feature-extraction/sentence-transformers/all-MiniLM-L6-v2';

export async function getEmbedding(text, apiToken) {
  if (!text || !text.trim()) {
    throw new Error('Text cannot be empty');
  }

  if (!apiToken) {
    throw new Error('HuggingFace API token is required');
  }

  try {
    const response = await fetch(HUGGINGFACE_API_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        inputs: text,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`HuggingFace API error: ${response.status} - ${errorText}`);
    }

    const embedding = await response.json();
    
    if (Array.isArray(embedding) && embedding.length > 0) {
      return Array.isArray(embedding[0]) ? embedding[0] : embedding;
    }

    throw new Error('Unexpected response format from HuggingFace API');
  } catch (error) {
    if (error.message.includes('HuggingFace API error')) {
      throw error;
    }
    throw new Error(`Failed to get embedding: ${error.message}`);
  }
}
