import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import multer from 'multer';
import { getEmbedding } from './services/embeddingService.js';
import { cosineSimilarity, similarityToPercentage } from './services/similarityService.js';
import { cleanText } from './utils/textCleaner.js';
import { extractTextFromPdf } from './services/pdfService.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

const upload = multer({ storage: multer.memoryStorage() });

app.use(cors());
app.use(express.json({ limit: '10mb' }));

app.get('/', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'RoleFit API',
    endpoints: {
      health: '/health',
      analyze: '/api/analyze',
      embedding: '/api/embedding'
    }
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', message: 'RoleFit backend is running' });
});

app.post('/api/analyze', upload.single('resume'), async (req, res) => {
  try {
    const jdText = req.body.jdText || req.body.jobDescriptionText;
    
    if (!jdText) {
      return res.status(400).json({
        error: 'Job description text is required',
      });
    }

    const apiToken = process.env.HUGGINGFACE_API_TOKEN;
    if (!apiToken) {
      return res.status(500).json({
        error: 'HuggingFace API token not configured',
      });
    }

    let resumeText;

    if (req.file) {
      const resumeBuffer = req.file.buffer;
      resumeText = await extractTextFromPdf(resumeBuffer);
    } else if (req.body.resumeText) {
      resumeText = req.body.resumeText;
    } else {
      return res.status(400).json({
        error: 'Either resume file or resume text is required',
      });
    }

    const cleanedResume = cleanText(resumeText);
    const cleanedJD = cleanText(jdText);

    const [resumeEmbedding, jdEmbedding] = await Promise.all([
      getEmbedding(cleanedResume, apiToken),
      getEmbedding(cleanedJD, apiToken),
    ]);

    const similarity = cosineSimilarity(resumeEmbedding, jdEmbedding);
    const percentage = similarityToPercentage(similarity);

    res.json({
      success: true,
      score: percentage,
      similarity: similarity,
      message: 'Analysis complete',
    });
  } catch (error) {
    console.error('Error in /api/analyze:', error);
    res.status(500).json({
      error: error.message || 'Internal server error',
    });
  }
});

app.post('/api/embedding', async (req, res) => {
  try {
    const { text } = req.body;

    if (!text) {
      return res.status(400).json({
        error: 'Text is required',
      });
    }

    const apiToken = process.env.HUGGINGFACE_API_TOKEN;
    if (!apiToken) {
      return res.status(500).json({
        error: 'HuggingFace API token not configured',
      });
    }

    const cleanedText = cleanText(text);
    const embedding = await getEmbedding(cleanedText, apiToken);

    res.json({
      success: true,
      embedding: embedding,
      dimension: embedding.length,
    });
  } catch (error) {
    console.error('Error in /api/embedding:', error);
    res.status(500).json({
      error: error.message || 'Internal server error',
    });
  }
});

app.listen(PORT, () => {
  console.log(`RoleFit backend running on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  if (!process.env.HUGGINGFACE_API_TOKEN) {
    console.warn('WARNING: HUGGINGFACE_API_TOKEN not set');
  }
});
