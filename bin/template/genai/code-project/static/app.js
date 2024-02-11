const form = document.getElementById("chat-form");
const userInput = document.getElementById("user-input");
const responseElem = document.getElementById("response");

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  const userInputValue = userInput.value.trim();

  if (!userInputValue) {
    return;
  }

  const response = await fetch("/chat", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ user_input: userInputValue }),
  });

  const responseData = await response.json();

  if (response.ok) {
    const chatResponse = responseData.response;
    responseElem.value = chatResponse;
  } else {
    alert("Error when fetching response from ChatGPT API.");
  }
});