# Instructions

- Following Playwright test failed.
- Explain why, be concise, respect Playwright best practices.
- Provide a snippet of code with the fix, if possible.

# Test info

- Name: tests\e2e_flow.spec.js >> Named Approvals and Management Status >> Step 1: Create a Material Request ticket
- Location: tests\e2e_flow.spec.js:127:5

# Error details

```
Test timeout of 30000ms exceeded.
```

```
Error: locator.selectOption: Test timeout of 30000ms exceeded.
Call log:
  - waiting for locator('select#category')
    - locator resolved to <select required="" id="category" name="category" class="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-white focus:ring-2 focus:ring-primary focus:border-primary transition-all">…</select>
  - attempting select option action
    2 × waiting for element to be visible and enabled
      - did not find some options
    - retrying select option action
    - waiting 20ms
    2 × waiting for element to be visible and enabled
      - did not find some options
    - retrying select option action
      - waiting 100ms
    57 × waiting for element to be visible and enabled
       - did not find some options
     - retrying select option action
       - waiting 500ms

```

# Page snapshot

```yaml
- generic [ref=e3]:
  - banner [ref=e4]:
    - generic [ref=e6]:
      - link "Logo" [ref=e7] [cursor=pointer]:
        - /url: /
        - img "Logo" [ref=e8]
      - button "Toggle dark mode" [ref=e10] [cursor=pointer]:
        - generic [ref=e11]: dark_mode
  - main [ref=e12]:
    - generic [ref=e13]:
      - heading "Raise a Support Ticket" [level=1] [ref=e14]
      - paragraph [ref=e15]: Fill out the form below and our team will get back to you shortly.
    - generic [ref=e16]:
      - generic [ref=e18]:
        - generic [ref=e19]:
          - generic [ref=e20]:
            - generic [ref=e21]: Full Name *
            - textbox "Full Name *" [ref=e22]:
              - /placeholder: John Doe
              - text: Named Approval Test
          - generic [ref=e23]:
            - generic [ref=e24]: Email Address *
            - textbox "Email Address *" [ref=e25]:
              - /placeholder: john@example.com
              - text: named-test@example.com
        - generic [ref=e26]:
          - generic [ref=e27]:
            - generic [ref=e28]: Mobile Number *
            - textbox "Mobile Number *" [active] [ref=e29]:
              - /placeholder: +91 98765 43210
              - text: "1122334455"
          - generic [ref=e30]:
            - generic [ref=e31]: Department *
            - combobox "Department *" [ref=e32] [cursor=pointer]:
              - option "Select a department" [selected]
              - option "Accounts"
              - option "Admin & IT"
              - option "BIU"
              - option "Designing"
              - option "Documentation"
              - option "HR"
              - option "Marketing/Business development"
              - option "Merchandising"
              - option "Operations"
              - option "Product Development"
              - option "Visual Merchandising"
        - generic [ref=e33]:
          - generic [ref=e34]:
            - generic [ref=e35]: Category *
            - combobox "Category *" [ref=e36] [cursor=pointer]:
              - option "Select a category" [selected]
              - option "Keyboard & mouse issue"
              - option "Mail storage issue"
              - option "Material request"
              - option "Network issue"
              - option "Others"
              - option "Outlook issue"
              - option "Printer issues"
              - option "Server issue"
              - option "Software issue"
              - option "System issue"
              - option "Tonner issues"
          - generic [ref=e37]:
            - generic [ref=e38]: Mode *
            - combobox "Mode *" [ref=e39] [cursor=pointer]:
              - option "Select mode" [selected]
              - option "Remote Support"
              - option "User End Support"
        - generic [ref=e40]:
          - generic [ref=e41]: Description
          - textbox "Description" [ref=e42]:
            - /placeholder: Please provide as much detail as possible... (Optional)
        - generic [ref=e43]:
          - generic [ref=e44]: Attachments (Images only) - Optional
          - generic [ref=e45] [cursor=pointer]:
            - button "Choose File" [ref=e46]
            - generic [ref=e47]:
              - generic [ref=e48]: cloud_upload
              - generic [ref=e49]:
                - generic [ref=e50]: Click to upload
                - paragraph [ref=e51]: or drag and drop
              - paragraph [ref=e52]: PNG, JPG up to 5MB
        - generic [ref=e53]:
          - button "Submit Ticket" [ref=e54] [cursor=pointer]
          - link "arrow_back Back to Home" [ref=e55] [cursor=pointer]:
            - /url: /
            - generic [ref=e56]: arrow_back
            - text: Back to Home
      - generic [ref=e57]:
        - generic [ref=e58]:
          - generic [ref=e59]: lock
          - text: Your data is securely encrypted
        - generic [ref=e60]:
          - link "Privacy Policy" [ref=e61] [cursor=pointer]:
            - /url: "#"
          - link "Help Center" [ref=e62] [cursor=pointer]:
            - /url: "#"
  - contentinfo [ref=e63]:
    - paragraph [ref=e64]: © 2024 Support Desk Inc. All rights reserved.
```

# Test source

```ts
  46  |         // The ticket ID is in a span with tracking-widest inside the success modal
  47  |         const ticketIdContainer = page.locator('div.fixed span.tracking-widest').first();
  48  |         await expect(ticketIdContainer).toBeVisible({ timeout: 20000 });
  49  |         
  50  |         ticketId = (await ticketIdContainer.innerText()).trim();
  51  |         console.log(`Captured Ticket ID: ${ticketId}`);
  52  |         expect(ticketId).toBeTruthy();
  53  |         expect(ticketId).toMatch(/[A-Z]{3,5}\d+[A-Z]*/);
  54  |     });
  55  | 
  56  |     test('Step 2: Check ticket status (Initial)', async ({ page }) => {
  57  |         await page.goto(`http://localhost:5173/status?ticketId=${ticketId}`);
  58  | 
  59  |         // Verify status is "Not Started"
  60  |         await expect(page.locator('text=Not Started')).toBeVisible();
  61  |         await expect(page.locator('text=E2E Test User')).toBeVisible();
  62  |     });
  63  | 
  64  |     test('Step 3: Admin login and ticket completion', async ({ page }) => {
  65  |         await page.goto('http://localhost:5173/admin');
  66  | 
  67  |         // Login (using provided credentials)
  68  |         await page.fill('input[type="email"]', 'admin@support.com');
  69  |         await page.fill('input[type="password"]', '123456');
  70  |         await page.click('button:has-text("Sign In")');
  71  | 
  72  |         // Wait for dashboard to load (look for the "All Tickets" button in sidebar)
  73  |         await expect(page.locator('button:has-text("All Tickets")')).toBeVisible({ timeout: 15000 });
  74  | 
  75  |         // Find the ticket in the table and click it (using id for uniqueness)
  76  |         const ticketRow = page.locator(`tr:has-text("${ticketId}")`).first();
  77  |         await expect(ticketRow).toBeVisible({ timeout: 10000 });
  78  |         await ticketRow.click();
  79  | 
  80  |         // Wait for detail panel to appear
  81  |         await page.waitForSelector('textarea[placeholder*="final comments"]', { state: 'attached', timeout: 5000 }).catch(() => {});
  82  | 
  83  |         // Update status to Completed first to reveal resolution comments textarea
  84  |         await page.locator('label:text-is("Status") + div select').selectOption('Completed');
  85  |         
  86  |         // Update assignee (using option text to disambiguate from header filter)
  87  |         await page.locator('select').filter({ has: page.locator('option:text-is("Assignee")') }).selectOption('Ruban');
  88  |         
  89  |         // Add resolution comments
  90  |         await page.fill('textarea[placeholder*="final comments"]', 'Issue resolved by E2E test script.');
  91  |         
  92  |         // Save changes (the button with the "check" icon)
  93  |         await page.click('button:has(span.material-symbols-outlined:text("check"))');
  94  |         
  95  |         // Success notification (toast)
  96  |         await expect(page.locator('text=Ticket updated successfully')).toBeVisible();
  97  |     });
  98  | 
  99  |     test('Step 4: Verify status update on Check Status page', async ({ page }) => {
  100 |         await page.goto(`http://localhost:5173/status?ticketId=${ticketId}`);
  101 | 
  102 |         // Verify status is now "Completed"
  103 |         await expect(page.locator('text=Completed')).toBeVisible();
  104 |         await expect(page.locator('text=Issue resolved by E2E test script.')).toBeVisible();
  105 |     });
  106 | 
  107 |     test('Step 5: Verify email notification content', async ({ request }) => {
  108 |         // Fetch the last sent email from the backend test endpoint
  109 |         const response = await request.get('http://127.0.0.1:443/api/test/last-email');
  110 |         expect(response.ok()).toBeTruthy();
  111 |         
  112 |         const emailData = await response.json();
  113 |         console.log('Last sent email:', emailData);
  114 |         
  115 |         // Verify email details
  116 |         expect(emailData.to).toContain('e2e@example.com');
  117 |         expect(emailData.subject).toContain('Resolved');
  118 |         expect(emailData.subject).toContain(ticketId);
  119 |         expect(emailData.body).toContain('Issue resolved by E2E test script.');
  120 |         expect(emailData.body).toContain('Ruban');
  121 |     });
  122 | });
  123 |  
  124 | test.describe('Named Approvals and Management Status', () => {
  125 |     let ticketId = '';
  126 |  
  127 |     test('Step 1: Create a Material Request ticket', async ({ page }) => {
  128 |         await page.goto('http://localhost:5173/');
  129 |  
  130 |         // Handle Branch Popup
  131 |         const supportTypeSelect = page.locator('div.fixed select').first();
  132 |         await supportTypeSelect.waitFor({ state: 'visible' });
  133 |         await supportTypeSelect.selectOption('IT Support');
  134 |         const branchSelect = page.locator('div.fixed select').nth(1);
  135 |         await branchSelect.selectOption('Cotton Concepts HO, Coimbatore');
  136 |         await page.click('button:has-text("Next")');
  137 |  
  138 |         // Fill form with Category that requires approvals
  139 |         await page.waitForSelector('input#fullName', { state: 'visible' });
  140 |         await page.fill('input#fullName', 'Named Approval Test');
  141 |         await page.fill('input#email', 'named-test@example.com');
  142 |         await page.fill('input#mobile', '1122334455');
  143 |  
  144 |         const categorySelect = page.locator('select#category');
  145 |         await expect(categorySelect.locator('option').nth(1)).toBeAttached();
> 146 |         await categorySelect.selectOption('Hardware/Assets'); // Requires approvals
      |                              ^ Error: locator.selectOption: Test timeout of 30000ms exceeded.
  147 |  
  148 |         const departmentSelect = page.locator('select#department');
  149 |         await expect(departmentSelect.locator('option').nth(1)).toBeAttached();
  150 |         await departmentSelect.selectOption('Admin & IT');
  151 |  
  152 |         await page.fill('textarea#description', 'Named approval verification ticket.');
  153 |         await page.click('button:has-text("Submit Ticket")');
  154 |  
  155 |         const ticketIdContainer = page.locator('div.fixed span.tracking-widest').first();
  156 |         await expect(ticketIdContainer).toBeVisible({ timeout: 10000 });
  157 |         ticketId = (await ticketIdContainer.innerText()).trim();
  158 |         console.log(`Named Approval Ticket ID: ${ticketId}`);
  159 |     });
  160 |  
  161 |     test('Step 2: Approve as Manager via API and Verify UI', async ({ page, request }) => {
  162 |         // Approve via API
  163 |         const response = await request.post(`http://127.0.0.1:443/api/approval/action/${ticketId}/Admin-Manager`, {
  164 |             form: {
  165 |                 action: 'Approve',
  166 |                 comments: 'Looks good to me',
  167 |                 receiver_name: 'Balaji Manager'
  168 |             }
  169 |         });
  170 |         expect(response.ok()).toBeTruthy();
  171 |  
  172 |         // Go to status page
  173 |         await page.goto(`http://localhost:5173/status?ticketId=${ticketId}`);
  174 |  
  175 |         // Verify named status is visible
  176 |         await expect(page.locator('text=Balaji Manager: Approved')).toBeVisible();
  177 |     });
  178 |  
  179 |     test('Step 3: Approve as Management (Multiple) via API and Verify UI', async ({ page, request }) => {
  180 |         // Management 1
  181 |         await request.post(`http://127.0.0.1:443/api/approval/action/${ticketId}/Management`, {
  182 |             form: { action: 'Approve', comments: 'Approve 1', receiver_name: 'Annie' }
  183 |         });
  184 |  
  185 |         // Management 2
  186 |         await request.post(`http://127.0.0.1:443/api/approval/action/${ticketId}/Management`, {
  187 |             form: { action: 'Approve', comments: 'Approve 2', receiver_name: 'Vanjinathan' }
  188 |         });
  189 |  
  190 |         // Go to status page
  191 |         await page.goto(`http://localhost:5173/status?ticketId=${ticketId}`);
  192 |  
  193 |         // Verify appended named status
  194 |         await expect(page.locator('text=Annie: Approved, Vanjinathan: Approved')).toBeVisible();
  195 |     });
  196 | });
  197 | 
```