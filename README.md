# RoleFit

RoleFit is a Flutter application that analyzes resume-to-job-description fit using semantic similarity. The app uses HuggingFace embeddings via a lightweight Node.js backend.

## Tech Stack

- **Frontend**: Flutter (Web + Mobile)
- **State Management**: Bloc
- **Backend**: Node.js + Express
- **AI**: HuggingFace Inference API (sentence-transformers/all-MiniLM-L6-v2)

## Architecture

- Flutter handles all user interaction
- Backend protects API tokens and handles AI calls
- Similarity calculation is deterministic and controlled by backend
- No auth, no sessions, minimal complexity

## Setup

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Set up HuggingFace API token:
   - Go to https://huggingface.co
   - Sign up (free)
   - Click profile → Settings → Access Tokens
   - Create a READ token (starts with `hf_...`)
   - Edit `backend/.env` file and replace `your_token_here` with your actual token:
   ```
   HUGGINGFACE_API_TOKEN=hf_your_actual_token_here
   PORT=3000
   ```
   
   **Note**: The `.env` file already exists. You just need to update the token value.

5. Start backend server:
```bash
npm start
```

Backend runs on http://localhost:3000

### Flutter Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Update API base URL in `lib/services/api_service.dart` if backend is not on localhost:3000

3. Run on web:
```bash
flutter run -d chrome
```

4. Run on mobile:
```bash
flutter run
```

## Usage

1. Start the backend server
2. Run Flutter app (web or mobile)
3. Enter resume text (or upload PDF on mobile)
4. Enter job description
5. Click "Analyze Fit" to get similarity score

## Project Structure

```
lib/
  bloc/           # Bloc state management
  models/         # Data models
  screens/        # UI screens
  services/       # API and PDF services
  widgets/        # Reusable widgets

backend/
  services/       # Embedding and similarity services
  utils/          # Text cleaning utilities
  index.js        # Express server
```

## API Endpoints

- `GET /health` - Health check
- `POST /api/analyze` - Analyze resume vs JD
  - Body: `{ resumeText: string, jobDescriptionText: string }`
  - Returns: `{ success: boolean, score: number, similarity: number }`
