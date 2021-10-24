type Options = {
  [index: string]: {
    default: any;
    ask?: boolean;
    rmS?: boolean;
  };
};

export const options: Options = {
  kport: {
    default: 80,
    ask: false,
    rmS: true,
  },
  port: {
    default: 8080,
    ask: true,
  },
};
