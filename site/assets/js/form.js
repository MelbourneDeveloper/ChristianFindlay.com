const safeFetch = async (url, options) => {
    try {
        return await fetch(url, options);
    } catch (error) {
        console.error('Fetch error:', error);
        return null;
    }
};

const handleFormSubmission = (formId) => {
    const form = document.getElementById(formId);
    if (!form) return;

        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            const submitButton = form.querySelector('button[type="submit"]');
        const errorElement = form.querySelector('#error');
        const successElement = form.querySelector('#success');
        const setDisplayState = (element, state) => element.style.display = state ? 'block' : 'none';
        const toggleElements = (state) => {
            setDisplayState(successElement, state === 'success');
            setDisplayState(errorElement, state === 'error');
        };
        const resetSubmitButton = () => {
            submitButton.classList.remove('loading');
            submitButton.disabled = false;
        }

        toggleElements('none');
        submitButton.classList.add('loading');
        submitButton.disabled = true;

        const formData = new FormData(form);

        if (typeof window !== 'undefined') {
            formData.set('page', window.location.pathname);
        }
        formData.set('submission_time', new Date().toISOString());

        const token = turnstile.getResponse();
        if (!token) {
            resetSubmitButton();
            alert('Please complete the Turnstile challenge');
            return;
        }
        formData.append('turnstileToken', token);

        const response = await safeFetch('https://forms-7fa3jw7jhq-uc.a.run.app/api/submit-form', {
            method: 'POST',
            body: formData,
            credentials: 'include'
        });

        if (response?.ok) {
            form.reset();
            turnstile.reset();
            toggleElements('success');
        } else {
            toggleElements('error');
        }
        resetSubmitButton();
    });
};

document.addEventListener('DOMContentLoaded', function () {
    handleFormSubmission('contactForm');
});