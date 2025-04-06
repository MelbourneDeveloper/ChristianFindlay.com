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

        try {

            e.preventDefault();

            // Get the elements
            const submitButton = form.querySelector('button[type="submit"]');
            const errorElement = form.querySelector('#error');
            const successElement = form.querySelector('#success');

            const setDisplayState = (element, state) => {
                if (element) element.style.display = state ? 'block' : 'none';
            };

            // Toggle the elements
            const toggleElements = (state) => {
                setDisplayState(successElement, state === 'success');
                setDisplayState(errorElement, state === 'error');
            };

            // Reset the submit button
            const resetSubmitButton = () => {
                if (submitButton) {
                    submitButton.classList.remove('loading');
                    submitButton.disabled = false;
                }
            }

            toggleElements('none');

            if (submitButton) {
                submitButton.classList.add('loading');
                submitButton.disabled = true;
            }

            const formData = new FormData(form);

            if (typeof window !== 'undefined') {
                formData.set('page', window.location.pathname);
            }
            formData.set('submission_time', new Date().toISOString());

            // Get the token
            let token = window.turnstile.getResponse();
            if (!token) {
                resetSubmitButton();
                alert('Please complete the Turnstile challenge');
                return;
            }

            formData.append('turnstileToken', token);

            // Submit the form
            const response = await safeFetch('https://forms-7fa3jw7jhq-uc.a.run.app/api/submit-form', {
                method: 'POST',
                body: formData,
                credentials: 'include'
            });

            if (response?.ok) {
                form.reset();
                window.turnstile.reset();
                toggleElements('success');
            } else {
                toggleElements('error');
            }
            resetSubmitButton();
        } catch (error) {
            console.error('Turnstile error:', error);
            resetSubmitButton();
            toggleElements('error');
            return;
        }
    });
};

document.addEventListener('DOMContentLoaded', function () {
    // Handle contact form
    handleFormSubmission('contactForm');

    // Handle newsletter forms
    handleFormSubmission('newsletterForm');
});