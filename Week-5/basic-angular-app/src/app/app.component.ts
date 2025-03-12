import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterModule],
  template: `
    <nav>
      <a routerLink="/">Home</a>
      <a routerLink="/about">About</a>
      <a routerLink="/contact">Contact</a>
    </nav>
    <router-outlet></router-outlet>
  `,
  styles: [`
    nav {
      padding: 1rem;
      background: #333;
      margin-bottom: 1rem;
    }
    nav a {
      color: white;
      padding: 0.5rem 1rem;
      text-decoration: none;
      margin-right: 1rem;
    }
    nav a:hover {
      background: #555;
      border-radius: 4px;
    }
  `]
})
export class AppComponent {
  title = 'basic-angular-app';
}