/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   builtin_unset.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: bstrong <bstrong@student.21-school.ru>     +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/02/04 23:33:19 by bstrong           #+#    #+#             */
/*   Updated: 2022/02/04 23:33:19 by bstrong          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "minishell.h"

static int	checker(char *key)
{
	int	error;
	int	i;

	error = 0;
	i = 0;
	if (!(ft_isalpha(key[i]) || key[i] == '_'))
		error = 1;
	while (key[++i])
	{
		if (!(ft_isalpha(key[i]) || ft_isdigit(key[i]) || key[i] == '_'))
		{
			error = 1;
			break ;
		}
	}
	if (error)
	{
		ft_putstr_fd("unset: ", 2);
		ft_putstr_fd(key, 2);
		ft_putendl_fd(": invalid parameter name", 2);
		return (1);
	}
	return (0);
}

static int	free_list(t_env *ptr)
{
	free(ptr->key);
	ptr->key = NULL;
	free(ptr->value);
	ptr->value = NULL;
	free(ptr);
	ptr = NULL;
	return (0);
}

static int	unset(t_env **env, t_list *key)
{
	t_env	*temp;
	t_env	*pre;
	int		len_key;

	if (!key)
		return (0);
	if (checker(key->content))
		return (1);
	temp = *env;
	len_key = ft_strlen(key->content) + 1;
	while (temp->next)
	{
		if (!ft_strncmp(key->content, temp->key, len_key))
			return (!(*env = temp->next) || free_list(temp));
		else if (!ft_strncmp(key->content, temp->next->key, len_key))
		{
			pre = temp->next;
			temp->next = temp->next->next;
			return (free_list(pre));
		}
		temp = temp->next;
	}
	return (0);
}

int	bin_unset(t_data *data, int i)
{
	t_list	*cmd;
	int		tmp;
	int 	ret;

	ret = 0;
	cmd = data->c[i]->cmd->next;
	if (!cmd)
		return (0);
	while (cmd)
	{
		tmp = unset(&data->env, cmd) != 0;
		if (tmp != 0)
			ret = tmp;
		cmd = cmd->next;
	}
	return (ret);
}
