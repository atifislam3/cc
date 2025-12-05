/**
 * ICT Trading Academy - Main JavaScript
 * 
 * Educational tool for learning Inner Circle Trader (ICT) concepts
 * with interactive visualizations and practice exercises.
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize tooltips
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Navbar background change on scroll
    const navbar = document.querySelector('.navbar');
    if (navbar) {
        window.addEventListener('scroll', function() {
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    }

    // Add animation classes when elements come into view
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.concept-card, .practice-card, .content-card').forEach(el => {
        observer.observe(el);
    });

    // Checklist local storage (for chart page)
    const checklistItems = document.querySelectorAll('.checklist-item input');
    checklistItems.forEach(item => {
        // Load saved state
        const savedState = localStorage.getItem(item.id);
        if (savedState === 'true') {
            item.checked = true;
        }

        // Save state on change
        item.addEventListener('change', function() {
            localStorage.setItem(this.id, this.checked);
        });
    });

    // Reset checklist button (if exists)
    const resetChecklistBtn = document.querySelector('.reset-checklist');
    if (resetChecklistBtn) {
        resetChecklistBtn.addEventListener('click', function() {
            checklistItems.forEach(item => {
                item.checked = false;
                localStorage.setItem(item.id, 'false');
            });
        });
    }

    // Concept card hover effect
    document.querySelectorAll('.concept-card').forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });

    // Progress tracking
    function updateProgress() {
        const completedConcepts = localStorage.getItem('completedConcepts') || '[]';
        const completed = JSON.parse(completedConcepts);
        
        document.querySelectorAll('.progress-item').forEach(item => {
            const conceptName = item.querySelector('.concept-name').textContent;
            if (completed.includes(conceptName)) {
                item.classList.add('completed');
            }
        });
    }

    // Mark concept as studied
    function markAsStudied(conceptName) {
        const completedConcepts = localStorage.getItem('completedConcepts') || '[]';
        const completed = JSON.parse(completedConcepts);
        if (!completed.includes(conceptName)) {
            completed.push(conceptName);
            localStorage.setItem('completedConcepts', JSON.stringify(completed));
        }
    }

    // SVG Animations for concept visualizations
    function animateFVG() {
        const fvgZone = document.querySelector('.fvg-zone');
        if (fvgZone) {
            fvgZone.style.animation = 'pulse 2s infinite';
        }
    }

    // Initialize animations
    animateFVG();

    // Console welcome message
    console.log('%c📈 ICT Trading Academy', 'color: #3498db; font-size: 24px; font-weight: bold;');
    console.log('%cLearn Inner Circle Trader concepts with visual examples!', 'color: #2ecc71; font-size: 14px;');
});

/**
 * Trading Session Timer
 * Shows which trading session is currently active
 * Note: Uses EST timezone. For accurate DST handling in production,
 * consider using a timezone library like Luxon or date-fns-tz.
 */
function updateSessionIndicator() {
    const now = new Date();
    // Check if DST is in effect (March - November in US)
    const jan = new Date(now.getFullYear(), 0, 1);
    const jul = new Date(now.getFullYear(), 6, 1);
    const isDST = now.getTimezoneOffset() < Math.max(jan.getTimezoneOffset(), jul.getTimezoneOffset());
    const estOffset = isDST ? -4 : -5; // EDT is -4, EST is -5
    const utc = now.getTime() + (now.getTimezoneOffset() * 60000);
    const estTime = new Date(utc + (3600000 * estOffset));
    const hours = estTime.getHours();

    const sessions = document.querySelectorAll('.session-item');
    sessions.forEach(session => session.classList.remove('active-session'));

    // Asian: 20:00-00:00
    // London: 02:00-05:00
    // New York: 07:00-10:00
    // London Close: 10:00-12:00

    if (hours >= 20 || hours < 0) {
        document.querySelector('.session-item:nth-child(1)')?.classList.add('active-session');
    } else if (hours >= 2 && hours < 5) {
        document.querySelector('.session-item:nth-child(2)')?.classList.add('active-session');
    } else if (hours >= 7 && hours < 10) {
        document.querySelector('.session-item:nth-child(3)')?.classList.add('active-session');
    } else if (hours >= 10 && hours < 12) {
        document.querySelector('.session-item:nth-child(4)')?.classList.add('active-session');
    }
}

// Update session indicator every minute
setInterval(updateSessionIndicator, 60000);

/**
 * Quiz Helper Functions
 */
const QuizManager = {
    currentQuestion: 0,
    score: 0,
    answers: [],

    init: function(totalQuestions) {
        this.totalQuestions = totalQuestions;
        this.updateProgress();
    },

    checkAnswer: function(selected, correct) {
        const isCorrect = selected === correct;
        this.answers.push({ selected, correct, isCorrect });
        if (isCorrect) this.score++;
        this.updateScore();
        return isCorrect;
    },

    nextQuestion: function() {
        this.currentQuestion++;
        this.updateProgress();
        return this.currentQuestion < this.totalQuestions;
    },

    updateProgress: function() {
        const progressBar = document.getElementById('progressBar');
        if (progressBar) {
            const percentage = ((this.currentQuestion + 1) / this.totalQuestions) * 100;
            progressBar.style.width = percentage + '%';
        }
    },

    updateScore: function() {
        const scoreDisplay = document.getElementById('score');
        if (scoreDisplay) {
            scoreDisplay.textContent = this.score;
        }
    },

    getResults: function() {
        const percentage = (this.score / this.totalQuestions) * 100;
        let message = '';
        let grade = '';

        if (percentage >= 90) {
            message = 'Excellent! You have mastered this concept!';
            grade = 'A';
        } else if (percentage >= 80) {
            message = 'Great job! You have a solid understanding.';
            grade = 'B';
        } else if (percentage >= 70) {
            message = 'Good work! Keep practicing to improve.';
            grade = 'C';
        } else if (percentage >= 60) {
            message = 'You\'re getting there. Review the concept and try again.';
            grade = 'D';
        } else {
            message = 'Keep studying! Review the materials and practice more.';
            grade = 'F';
        }

        return { score: this.score, total: this.totalQuestions, percentage, message, grade };
    },

    reset: function() {
        this.currentQuestion = 0;
        this.score = 0;
        this.answers = [];
        this.updateProgress();
        this.updateScore();
    }
};

/**
 * Chart Analysis Helper
 */
const ChartAnalysis = {
    checklist: {
        bias: false,
        structure: false,
        liquidity: false,
        fvg: false,
        ob: false,
        pd: false,
        session: false
    },

    toggleItem: function(item) {
        if (this.checklist.hasOwnProperty(item)) {
            this.checklist[item] = !this.checklist[item];
            this.saveChecklist();
        }
    },

    saveChecklist: function() {
        localStorage.setItem('chartChecklist', JSON.stringify(this.checklist));
    },

    loadChecklist: function() {
        const saved = localStorage.getItem('chartChecklist');
        if (saved) {
            this.checklist = JSON.parse(saved);
        }
        return this.checklist;
    },

    resetChecklist: function() {
        for (let key in this.checklist) {
            this.checklist[key] = false;
        }
        this.saveChecklist();
    },

    getCompletionPercentage: function() {
        const total = Object.keys(this.checklist).length;
        const completed = Object.values(this.checklist).filter(v => v).length;
        return Math.round((completed / total) * 100);
    }
};
