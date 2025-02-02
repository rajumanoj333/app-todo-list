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
