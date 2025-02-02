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
