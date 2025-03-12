import { Component } from '@angular/core';

@Component({
  selector: 'app-home',
  standalone: true,
  template: `
    <div class="home">
      <h1>Welcome to Our App</h1>
      <p>This is the home page. Use the navigation above to explore other pages.</p>
    </div>
  `,
  styles: [`
    .home {
      padding: 2rem;
      text-align: center;
    }
    h1 {
      color: #333;
      margin-bottom: 1rem;
    }
  `]
})
export class HomeComponent {} 