# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: lcoreen <lcoreen@student.21-school.ru>     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/10/20 12:42:26 by bstrong           #+#    #+#              #
#    Updated: 2022/02/28 16:26:09 by lcoreen          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME	= minishell
CC		= clang
FLAGS	= -Wall -Wextra -Werror -g

INCLUDE	= -I ./includes -I ./libft -I /opt/homebrew/opt/readline/include

LIBS	= -L./libft -lft -L/opt/homebrew/opt/readline/lib -lreadline

HEADERS	= ./includes/minishell.h

VPATH := ./builtin/ ./parser/ ./utils/ ./pipe/

SRC_BUILTIN	=	./builtin/
SRC_PARSER	=	./parser/
SRC_UTILS	=	./utils/
SRC_PIPE	=	./pipe/

SRC_LST_BIN		=	builtin_cd.c		builtin_echo.c		builtin_env.c\
					builtin_exit.c		builtin_export.c	builtin_pwd.c\
					builtin_unset.c		check_builtin.c

SRC_LST_PARS	=	handle_signs.c		parser.c			start.c\
					preparser.c			redirect.c

SRC_LST_PIPE	=	execute_cmd.c		get_cmd.c			wait.c


SRC_LST_UTILS	=	utils.c				utils_env1.c		utils_env2.c\
					signal_well.c		data.c				free_memory.c\
					errors.c			debug.c				check_funcs.c\
					cmd.c

OBJ_PATH		=	./bin/

OBJ				=	$(addprefix $(OBJ_PATH), $(patsubst %.c, %.o, $(SRC_LST_BIN)))\
					$(addprefix $(OBJ_PATH), $(patsubst %.c, %.o, $(SRC_LST_PARS)))\
					$(addprefix $(OBJ_PATH), $(patsubst %.c, %.o, $(SRC_LST_PIPE)))\
					$(addprefix $(OBJ_PATH), $(patsubst %.c, %.o, $(SRC_LST_UTILS)))\
					$(addprefix $(OBJ_PATH), $(patsubst %.c, %.o, main.c))

.PHONY	:	all clean fclean re

all	:	$(LIBS) $(OBJ_PATH) $(NAME)

$(LIBS)	:
		make -C ./libft all

$(OBJ_PATH)	:
		mkdir -p $(OBJ_PATH)

$(NAME) : $(OBJ)
		$(CC) $(OBJ) $(LIBS) -o $@

$(OBJ_PATH)%.o : %.c $(HEADERS)
		$(CC) $(FLAGS) $(INCLUDE) -c $< -o $@

clean :
	make -C ./libft clean
	rm -rf $(OBJ_PATH)

fclean : clean
	make -C ./libft fclean
	rm -f $(NAME)

re :fclean all