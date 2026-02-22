import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "submit"]

  connect() {
    this.scrollToBottom()
  }

  handleKeydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.send(event)
    }
  }

  autoResize() {
    const input = this.inputTarget
    input.style.height = "auto"
    input.style.height = Math.min(input.scrollHeight, 200) + "px"
  }

  async send(event) {
    event.preventDefault()

    const content = this.inputTarget.value.trim()
    if (!content) return

    // Disable form
    this.inputTarget.disabled = true
    this.submitTarget.disabled = true

    // Clear input
    this.inputTarget.value = ""
    this.inputTarget.style.height = "auto"

    // Remove empty state
    const emptyState = document.getElementById("empty-state")
    if (emptyState) emptyState.remove()

    // Add user message to UI
    const messagesContainer = document.getElementById("messages")
    this.appendMessage("user", content)

    // Add pending assistant message
    const assistantDiv = this.appendMessage("assistant", "", true)

    try {
      // Send request with SSE
      const response = await fetch("/messages", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        },
        body: `content=${encodeURIComponent(content)}`
      })

      const reader = response.body.getReader()
      const decoder = new TextDecoder()

      while (true) {
        const { done, value } = await reader.read()
        if (done) break

        const text = decoder.decode(value)
        const lines = text.split("\n")

        for (const line of lines) {
          if (line.startsWith("data: ")) {
            try {
              const data = JSON.parse(line.slice(6))

              if (data.error) {
                this.updateAssistantMessage(assistantDiv, `Error: ${data.error}`, false)
              } else if (data.done) {
                this.updateAssistantMessage(assistantDiv, null, false)
              } else if (data.content) {
                this.updateAssistantMessage(assistantDiv, data.content, true)
              }
            } catch (e) {
              // Skip malformed JSON
            }
          }
        }
      }
    } catch (error) {
      this.updateAssistantMessage(assistantDiv, `Error: ${error.message}`, false)
    }

    // Re-enable form
    this.inputTarget.disabled = false
    this.submitTarget.disabled = false
    this.inputTarget.focus()
  }

  appendMessage(role, content, streaming = false) {
    const messagesContainer = document.getElementById("messages")

    const div = document.createElement("div")
    div.className = `flex gap-3 ${role === "user" ? "justify-end" : ""}`

    if (role === "assistant") {
      div.innerHTML = `
        <div class="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center text-sm">🤖</div>
        <div class="max-w-[80%] bg-gray-700 rounded-lg px-4 py-2">
          <div class="message-content prose prose-invert prose-sm max-w-none">
            ${streaming ? '<span class="animate-pulse">●</span> 思考中...' : this.formatContent(content)}
          </div>
        </div>
      `
    } else {
      div.innerHTML = `
        <div class="max-w-[80%] bg-blue-600 rounded-lg px-4 py-2">
          <div class="prose prose-invert prose-sm max-w-none">${this.formatContent(content)}</div>
        </div>
        <div class="w-8 h-8 rounded-full bg-gray-600 flex items-center justify-center text-sm">👤</div>
      `
    }

    messagesContainer.appendChild(div)
    this.scrollToBottom()

    return div
  }

  updateAssistantMessage(div, content, streaming) {
    const contentDiv = div.querySelector(".message-content")
    if (content !== null) {
      contentDiv.innerHTML = streaming
        ? this.formatContent(content) + ' <span class="animate-pulse">●</span>'
        : this.formatContent(content)
    } else {
      // Remove streaming indicator
      const indicator = contentDiv.querySelector(".animate-pulse")
      if (indicator) indicator.remove()
    }
    this.scrollToBottom()
  }

  formatContent(content) {
    // Basic formatting - convert newlines to <br>
    return content
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/\n/g, "<br>")
  }

  scrollToBottom() {
    const messagesContainer = document.getElementById("messages")
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  }
}
