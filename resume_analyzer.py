import PyPDF2
import nltk
nltk.download('stopwords')
nltk.download('punkt')
nltk.download('punkt_tab')
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

skills_list = [
    "java", "python", "sql", "html", "css",
    "javascript", "react", "node", "mongodb",
    "machine learning", "data analysis",
    "marketing", "seo", "analytics", "roi"
]

stop_words = set(stopwords.words('english'))

def clean_path(path):
    return path.strip().replace('"', '')

def read_text_file(path):
    path = clean_path(path)
    try:
        with open(path, 'r', encoding='utf-8') as f:
            return f.read().lower()
    except Exception as e:
        print("Error reading file:", e)
        return ""

def read_pdf_file(path):
    path = clean_path(path)
    text = ""
    try:
        with open(path, 'rb') as f:
            reader = PyPDF2.PdfReader(f)
            for page in reader.pages:
                content = page.extract_text()
                if content:
                    text += content
        return text.lower()
    except Exception as e:
        print("Error reading PDF:", e)
        return ""

def preprocess(text):
    tokens = word_tokenize(text)
    filtered = []

    for word in tokens:
        if word.isalnum() and word not in stop_words:
            filtered.append(word)

    return filtered

def extract_skills(tokens):
    found = []

    for skill in skills_list:
        if skill in " ".join(tokens):
            found.append(skill)

    return found

def match_score(resume_skills, job_skills):

    if len(job_skills) == 0:
        return 0

    match = 0

    for skill in job_skills:
        if skill in resume_skills:
            match += 1

    return (match / len(job_skills)) * 100

def missing_skills(resume_skills, job_skills):

    missing = []

    for skill in job_skills:
        if skill not in resume_skills:
            missing.append(skill)

    return missing

def main():

    print("=== Resume Analyzer (NLP Version) ===")

    print("1. Text Resume")
    print("2. PDF Resume")

    choice = input("Enter choice: ")

    if choice == "1":
        resume = read_text_file(input("Enter resume path: "))
    elif choice == "2":
        resume = read_pdf_file(input("Enter resume PDF path: "))
    else:
        print("Invalid choice")
        return

    print("\nPaste Job Description:")
    job = input().lower()

    resume_tokens = preprocess(resume)
    job_tokens = preprocess(job)

    resume_skills = extract_skills(resume_tokens)
    job_skills = extract_skills(job_tokens)

    score = match_score(resume_skills, job_skills)
    missing = missing_skills(resume_skills, job_skills)

    print("\n===== RESULT =====")
    print("Resume Skills:", resume_skills)
    print("Job Skills:", job_skills)
    print("Match Score:", round(score, 2), "%")
    print("Missing Skills:", missing)

    if score >= 75:
        print("Excellent Match")
    elif score >= 50:
        print("Good Match")
    else:
        print("Needs Improvement")

main()