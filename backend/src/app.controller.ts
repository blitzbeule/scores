import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  constructor() {}

  @Get()
  getHello(): string {
    return `<h1>scores-2 backend service</h1><br><p>This is only an api for machines not for humans. But all is up and running. Please make sure this page is not reachable outside of your private network!</p>`
  }
}
