document.addEventListener("DOMContentLoaded", () => {
  const paidByDropdown = document.getElementById("expense_paid_by");
  const participantCheckboxes = document.querySelectorAll("[name^='expense[participants_attributes]']");
  
  paidByDropdown.addEventListener("change", () => {
    const selectedUserId = paidByDropdown.value;
    
    participantCheckboxes.forEach(checkbox => {
      if (checkbox.value === selectedUserId) {
        checkbox.checked = true;
      } else {
        checkbox.checked = false;
      }
    });
  });

  let counter = document.querySelectorAll('.item_fields').length + 1; // Start counting from the number of existing items
  document.getElementById("add-item").addEventListener("click", () => {
    debugger
    const itemsDiv = document.getElementById("items");
    const newItemFields = document.createElement("div");
    newItemFields.innerHTML = `
      <div class="item_fields">
        <h5>Item ${counter}</h5>
        <div class="field">
          <label for="expense_items_attributes_${Date.now()}_name">Name</label>
          <input type="text" name="expense[items_attributes][${Date.now()}][name]" id="expense_items_attributes_${Date.now()}_name" required>
        </div>
        <div class="field">
          <label for="expense_items_attributes_${Date.now()}_price">Price</label>
          <input type="number" name="expense[items_attributes][${Date.now()}][price]" id="expense_items_attributes_${Date.now()}_price" required>
        </div>
        <div class="field">
          <label for="expense_items_attributes_${Date.now()}_quantity">Quantity</label>
          <input type="number" name="expense[items_attributes][${Date.now()}][quantity]" id="expense_items_attributes_${Date.now()}_quantity" required>
        </div>
      </div>
    `;
    itemsDiv.appendChild(newItemFields);
    counter++; // Increment the counter for the next item
  });
});