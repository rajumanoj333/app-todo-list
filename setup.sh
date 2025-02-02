#!/bin/bash

# Set up a new Angular project and set up the To-Do list app

# Exit if any command fails
set -e

echo "Starting the Angular To-Do List App setup..."

# Step 1: Install Angular CLI globally if not already installed
if ! command -v ng &> /dev/null
then
    echo "Angular CLI is not installed. Installing Angular CLI globally..."
    npm install -g @angular/cli
else
    echo "Angular CLI is already installed."
fi

# Step 2: Create a new Angular project named todo-app
echo "Creating Angular project 'todo-app'..."
ng new todo-app --routing=false --style=css --skip-install

cd todo-app

# Step 3: Install dependencies (we skip installation during creation, so let's install now)
echo "Installing project dependencies..."
npm install

# Step 4: Generate TodoService and TodoListComponent
echo "Generating TodoService and TodoListComponent..."
ng generate service todo
ng generate component todo-list

# Step 5: Update TodoService with methods to handle tasks
echo "Updating TodoService with task management logic..."
cat > src/app/todo.service.ts <<EOL
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class TodoService {
  private todos: { id: number, task: string, completed: boolean }[] = [];

  constructor() {}

  getTodos() {
    return this.todos;
  }

  addTodo(task: string) {
    const newTodo = {
      id: this.todos.length + 1,
      task,
      completed: false
    };
    this.todos.push(newTodo);
  }

  toggleComplete(id: number) {
    const todo = this.todos.find(t => t.id === id);
    if (todo) {
      todo.completed = !todo.completed;
    }
  }

  removeTodo(id: number) {
    this.todos = this.todos.filter(t => t.id !== id);
  }
}
EOL

# Step 6: Update TodoListComponent to use the TodoService
echo "Updating TodoListComponent to manage the to-do list..."
cat > src/app/todo-list/todo-list.component.ts <<EOL
import { Component, OnInit } from '@angular/core';
import { TodoService } from '../todo.service';

@Component({
  selector: 'app-todo-list',
  templateUrl: './todo-list.component.html',
  styleUrls: ['./todo-list.component.css']
})
export class TodoListComponent implements OnInit {
  todos = this.todoService.getTodos();
  newTask: string = '';

  constructor(private todoService: TodoService) {}

  ngOnInit(): void {
    this.todos = this.todoService.getTodos();
  }

  addTodo(): void {
    if (this.newTask.trim()) {
      this.todoService.addTodo(this.newTask);
      this.newTask = '';
    }
  }

  toggleComplete(id: number): void {
    this.todoService.toggleComplete(id);
  }

  removeTodo(id: number): void {
    this.todoService.removeTodo(id);
  }
}
EOL

# Step 7: Create the HTML structure for TodoListComponent
echo "Updating TodoListComponent HTML..."
cat > src/app/todo-list/todo-list.component.html <<EOL
<div class="todo-container">
  <h1>My To-Do List</h1>

  <input 
    type="text" 
    [(ngModel)]="newTask" 
    placeholder="Add a new task"
    (keyup.enter)="addTodo()" />

  <button (click)="addTodo()">Add Task</button>

  <ul>
    <li *ngFor="let todo of todos">
      <span [class.completed]="todo.completed" (click)="toggleComplete(todo.id)">
        {{ todo.task }}
      </span>
      <button (click)="removeTodo(todo.id)">Delete</button>
    </li>
  </ul>
</div>
EOL

# Step 8: Add basic CSS to style the to-do list
echo "Adding some basic CSS for styling..."
cat > src/app/todo-list/todo-list.component.css <<EOL
.todo-container {
  width: 300px;
  margin: 0 auto;
  text-align: center;
  font-family: Arial, sans-serif;
}

input {
  padding: 8px;
  width: 80%;
  margin: 10px;
}

button {
  padding: 5px 10px;
  margin-top: 10px;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: flex;
  justify-content: space-between;
  margin: 5px 0;
}

span.completed {
  text-decoration: line-through;
  color: gray;
}
EOL

# Step 9: Modify the AppComponent to include the TodoListComponent
echo "Updating AppComponent to include TodoListComponent..."
cat > src/app/app.component.html <<EOL
<app-todo-list></app-todo-list>
EOL

# Step 10: Update AppModule to include FormsModule
echo "Updating AppModule to import FormsModule..."
sed -i "s/import { NgModule } from '@angular\/core';/import { NgModule } from '@angular\/core';\nimport { FormsModule } from '@angular/forms';/" src/app/app.module.ts

sed -i "s/declarations: \[AppComponent\],/declarations: \[AppComponent, TodoListComponent\],/" src/app/app.module.ts

sed -i "s/import { BrowserModule } from '@angular\/platform-browser';/import { BrowserModule } from '@angular\/platform-browser';\nimport { FormsModule } from '@angular\/forms';/" src/app/app.module.ts

# Step 11: Run the Angular development server
echo "Starting Angular development server..."
ng serve --open

echo "Setup completed successfully! The To-Do list app should be running now."
