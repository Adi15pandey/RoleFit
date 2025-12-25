# RoleFit Backend

Minimal Express backend for RoleFit that handles embeddings and similarity calculations.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Set up HuggingFace token:
   - Go to https://huggingface.co/settings/tokens
   - Create a READ token (starts with `hf_...`)
   - Edit `.env` file and replace `your_token_here` with your actual token:
   ```
   HUGGINGFACE_API_TOKEN=hf_your_actual_token_here
   PORT=3000
   ```

   **Important**: The variable name is `HUGGINGFACE_API_TOKEN` (not `HF_TOKEN`)

4. Start server:
```bash
npm start
```

## API Endpoints

- `GET /health` - Health check
- `POST /api/analyze` - Analyze resume vs job description
- `POST /api/embedding` - Get embedding for text (debug)

## Architecture

- Accepts resume and JD text
- Calls HuggingFace API for embeddings
- Calculates cosine similarity (deterministic)
- Returns similarity score

